# Documentación — Bunwe

App de sueño gamificada. Equipo de 4 personas: Raspberry Pi (servidor) + Flutter (app).

Esta guía está pensada para que **cualquiera del equipo** entienda cómo encaja todo y pueda modificar su parte sin romper las de los demás. Si sos nuevo en el proyecto, leé la sección 1 y 2, después salteá a la sección de tu rol.

---

## 0. Quién toca qué

| P | Rol | Carpeta que dueña | Sección |
|---|---|---|---|
| P1 | Infra + servidor (FastAPI, Pi, Tailscale) | `API/`, la Pi | 3 |
| P2 | Base de datos | `BD/` | 5 |
| P3 | App Flutter | `bunweflut/` | 4 |
| P4 | Lógica Python | `PYTHON/` | 3 |

**La regla de oro:** todo se comunica por un **contrato JSON** (sección 2). Mientras las claves de ese JSON no cambien, cada uno trabaja por su lado sin pisarse. Si necesitás cambiar una clave, avisá a las otras P **antes** de escribir código.

---

## 1. Arquitectura

```
┌─────────────┐   HTTP + JSON    ┌──────────────┐   SQL    ┌─────────────┐
│   Flutter   │ ───────────────► │   FastAPI    │ ───────► │   MariaDB   │
│ (teléfono)  │ ◄─────────────── │  (Raspberry) │ ◄─────── │ (Raspberry) │
└─────────────┘                  └──────────────┘          └─────────────┘
     P3                          P1 (infra) + P4 (lógica)        P2
        └──────────── red vía Tailscale (100.75.19.64) ───────────┘
```

- **Flutter** pinta pantallas y pide/envía datos por HTTP.
- **FastAPI** recibe la petición, llama a la lógica Python, devuelve JSON.
- **MariaDB** guarda usuarios y noches (todo en la Pi).
- **Tailscale** conecta el teléfono con la Pi desde cualquier red.

---

## 2. El contrato JSON — lo más importante

Es el idioma común entre la app (P3) y la lógica (P4). **Nadie lo cambia solo.**

### Respuesta de `GET /historial/{usuario_id}`

```json
{
  "puntuacion": 100,
  "horas": 8.0,
  "racha_dias": 3,
  "ultima_noche": "2026-07-02",
  "historial": [
    { "dia": "Mie", "horas": 8.0 },
    { "dia": "Jue", "horas": 7.75 }
  ]
}
```

### Endpoints (los que va a exponer el FastAPI)

| Método + ruta | Envía | Devuelve |
|---|---|---|
| `GET /historial/{usuario_id}` | — | el JSON de arriba |
| `POST /guardar` | `{usuario_id, fecha, acostarse, despertar}` | `{ok: true, horas: 8.0}` |
| `POST /registro` | `{nombre, password, meta_horas}` | `{usuario_id: 5}` |
| `POST /login` | `{nombre, password}` | `{usuario_id: 5}` o error |

`fecha` = `"YYYY-MM-DD"`, `acostarse`/`despertar` = `"HH:MM"`.

---

## 3. Backend: lógica Python + FastAPI (P4 y P1)

Vive en `PYTHON/`. Está partido en dos capas a propósito: **lógica pura** (no sabe de base de datos, se prueba sola) y **acceso a datos** (habla con MariaDB).

### 3.1 `funciones/funciones.py` — lógica pura

Funciones que reciben datos y devuelven datos. Cero base de datos. Es el corazón del proyecto.

| Función | Qué hace |
|---|---|
| `horas_dormidas(acostarse, despertar)` | Horas entre dos `"HH:MM"`. Maneja el cruce de medianoche (23:30 → 07:00 = 7.5). |
| `calcular_puntuacion(horas, meta)` | `(puntuacion, mensaje)`. `min(horas/meta, 1) × 100`, tope 100, nunca resta. Avisa si dormís de más. |
| `cumplio_meta(horas, meta)` | `True` si `horas >= meta`. |
| `calcular_racha(fechas_cumplidas, hasta)` | Días consecutivos cumplidos hasta la última noche. Si anoche no cumpliste, 0. |
| `armar_respuesta(registros, meta)` | Arma el JSON del contrato. |
| `hashear_password(password)` | `"pbkdf2_sha256$iter$salt$hash"`. Salt aleatorio, nunca texto plano. |
| `verificar_password(password, guardado)` | Compara en tiempo constante. |

### 3.2 `funciones/llamada_db.py` — acceso a MariaDB

Envuelve la lógica pura con las consultas. Usa `pymysql`.

| Función | Qué hace |
|---|---|
| `crear_usuario(nombre, password, meta_horas)` | Hashea e inserta. Devuelve el `id`. |
| `login(nombre, password)` | `id` si la clave es correcta, si no `None`. |
| `guardar_noche(usuario_id, fecha, acostarse, despertar)` | Calcula horas e inserta. Si la fecha ya existe, actualiza. |
| `get_historial(usuario_id)` | Lee las noches + la meta y arma el JSON del contrato. |

El `CONFIG` (arriba del archivo) es lo único que cambia según dónde corra:
- Desde tu PC: `host = "100.75.19.64"`.
- Desde la propia Pi (donde correrá el FastAPI): `host = "localhost"`.

### 3.3 FastAPI — cómo se ve (esqueleto)

El FastAPI es fino: solo envuelve las funciones de `llamada_db.py` en endpoints. Así se va a ver `API/main.py`:

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from funciones import llamada_db as db

app = FastAPI()
# ponytail: allow_origins=["*"] sirve para desarrollo; achicar a la IP real en producción
app.add_middleware(
    CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"]
)

class Noche(BaseModel):      # el cuerpo del POST se declara con Pydantic
    usuario_id: int
    fecha: str
    acostarse: str
    despertar: str

@app.get("/historial/{usuario_id}")   # {usuario_id} = parámetro de ruta
def historial(usuario_id: int):
    return db.get_historial(usuario_id)

@app.post("/guardar")
def guardar(n: Noche):
    horas = db.guardar_noche(n.usuario_id, n.fecha, n.acostarse, n.despertar)
    return {"ok": True, "horas": horas}
```

Se arranca en la Pi con:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

`--host 0.0.0.0` es **obligatorio** para que el teléfono alcance el servidor. Verificar en el navegador: `http://100.75.19.64:8000/historial/1`.

### 3.4 Recetas para P4 (lógica)

- **Quiero cambiar cómo se calcula la puntuación** → tocás **solo** `calcular_puntuacion` en `funciones.py`, y corrés `python test_funciones.py`. Nada más se entera. Si cambia el rango o el significado, avisá a P3 (es un valor del contrato).
- **Quiero cambiar la regla de la racha** → solo `calcular_racha` / `cumplio_meta`. Corré los tests.
- **Quiero agregar un endpoint nuevo** → una función en `llamada_db.py` + un `@app.get/post` en `main.py`.
- **Quiero guardar un dato nuevo** (que persista) → es un cambio de punta a punta: columna en la BD (avisar a P2) → query en `llamada_db.py` → agregarlo al contrato JSON (avisar a P3). Si es un dato **calculado**, no toques la BD: se calcula en `funciones.py`.

### 3.5 Cómo correr y probar

```bash
cd PYTHON
python -m venv .venv
source .venv/bin/activate.fish   # bash: source .venv/bin/activate
pip install pymysql
python test_funciones.py         # prueba la lógica pura (sin base)
python demo_db.py                # prueba de punta a punta contra MariaDB
```

---

## 4. App Flutter (P3)

Vive en `bunweflut/lib/`. Estructura limpia y **no sobre-diseñada** — buena base.

### 4.1 Carpetas

```
lib/
├── main.dart              Arranque de la app
├── core/                  Transversal
│   ├── colors.dart        Paleta (todos los colores en un lugar)
│   ├── theme.dart         Tema global (fuentes, botones, inputs)
│   └── routes.dart        Rutas: splash → login → home
├── widgets/               Piezas reutilizables (+ sheets/ = paneles inferiores)
└── screens/               Una carpeta por pantalla (splash, auth, home, goals, sleep, store, profile...)
```

### 4.2 Navegación

`main.dart` arranca en `splash` y define tema + rutas. Tras el login, `HomeScreen` usa un **`IndexedStack` + barra inferior**: las 5 pestañas quedan vivas y se cambia con `setState`. Los detalles (puntuación, racha, nivel) se abren como **bottom sheets**, no como pantallas nuevas.

### 4.3 Dónde están los datos hoy (y cómo conectarlos)

Ahora los datos están **hardcodeados** como constantes en cada pantalla. Ej. en `dashboard_tab.dart`:

```dart
static const int _score = 85;
static const int _streakDays = 12;
```

Para conectar con la Pi (hito 5) hacen falta **tres piezas mínimas** — nada más:

**1. Un modelo** (`models/sleep_data.dart`) que mapee el contrato:

```dart
class SleepData {
  final int puntuacion;
  final double horas;
  final int rachaDias;
  final String? ultimaNoche;
  final List<dynamic> historial;

  SleepData.fromJson(Map<String, dynamic> j)
      : puntuacion = j['puntuacion'],
        horas = (j['horas'] as num).toDouble(),
        rachaDias = j['racha_dias'],
        ultimaNoche = j['ultima_noche'],
        historial = j['historial'];
}
```

**2. Un cliente HTTP** (`services/api_service.dart`) usando el paquete `http`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

const _base = 'http://100.75.19.64:8000';

Future<SleepData> getHistorial(int usuarioId) async {
  final r = await http.get(Uri.parse('$_base/historial/$usuarioId'));
  return SleepData.fromJson(jsonDecode(r.body));
}

Future<void> guardarNoche(int uid, String fecha, String acostarse, String despertar) async {
  await http.post(
    Uri.parse('$_base/guardar'),
    headers: {'Content-Type': 'application/json'},   // sin esto, http manda text/plain
    body: jsonEncode({
      'usuario_id': uid, 'fecha': fecha,
      'acostarse': acostarse, 'despertar': despertar,
    }),
  );
}
```

**3. Estado con `FutureBuilder`** en la pantalla:

```dart
FutureBuilder<SleepData>(
  future: getHistorial(usuarioId),
  builder: (context, snap) {
    if (!snap.hasData) return const CircularProgressIndicator();
    final data = snap.data!;
    return Text('${data.puntuacion} pts');   // en vez de _score
  },
)
```

> **No metan Provider / Bloc / Riverpod todavía.** Para el tamaño de esta app, `FutureBuilder` + `setState` alcanza y sobra. Agregar una librería de estado ahora es sobre-ingeniería.

Falta agregar el paquete `http` en `pubspec.yaml` (`flutter pub add http`).

### 4.4 Recetas para P3 (Flutter)

- **Quiero cambiar un color o la fuente** → `core/colors.dart` / `core/theme.dart`. Un solo lugar.
- **Quiero agregar una pantalla** → nueva carpeta en `screens/`, y la enganchás en `core/routes.dart` o como pestaña en `HomeScreen`.
- **Quiero mostrar un dato del backend** → las 3 piezas de arriba (modelo + service + `FutureBuilder`).
- **Quiero cambiar un texto/número de prueba** → por ahora están como `static const` en cada pantalla; buscalos ahí.

### 4.5 Simplificaciones sugeridas (opcionales)

- El bloque `showModalBottomSheet(context: ..., isScrollControlled: true, ...)` se repite ~6 veces en `dashboard_tab.dart` → se puede reducir a un helper `showSheet(context, widget)` en `core/`.
- Los días de la semana están escritos dos veces (`_weekLabels` y `days` en `_miniStreakDots`) → una sola constante en `core/`.

---

## 5. Base de datos (P2)

⚠️ **La base actual NO es la definitiva.** Es el **núcleo** (MVP): sólido y probado, pero parcial. Falta la gamificación.

### 5.1 Esquema actual (`BD/schema.sql`)

```sql
usuarios(id, nombre, password_hash, meta_horas, monedas)
noches(id, usuario_id, fecha, hora_acostarse, hora_despertar, horas)
```

**Regla que se respeta:** no se guarda lo que se puede calcular. `puntuacion`, `cumplio`, promedios, racha, etc. **no** son columnas — se calculan al leer, desde `funciones.py`. Guardar valores derivados es la causa nº1 de bases desincronizadas.

### 5.2 Cómo aplicar el esquema (en DBeaver)

1. Conectá a la Pi (`100.75.19.64`, base `bunwe_app`).
2. Abrí `schema.sql` y ejecutá con **`Alt+X`** ("Ejecutar script SQL"), **no** con `Ctrl+Enter` — MariaDB no ejecuta varias sentencias juntas con `Ctrl+Enter`.
3. Después `seed.sql` igual, con `Alt+X`.

Para que Python entre de forma **remota**, el usuario de MariaDB tiene que existir para host `%` (esto se corre una vez, en la Pi con `sudo mariadb`):

```sql
CREATE USER IF NOT EXISTS 'sleep_user'@'%' IDENTIFIED BY 'la_clave';
GRANT ALL PRIVILEGES ON bunwe_app.* TO 'sleep_user'@'%';
FLUSH PRIVILEGES;
```

### 5.3 Lo que falta para la definitiva (fase 2 — gamificación)

Siete tablas más, en pares "catálogo + enlace por usuario":

| Catálogo | Enlace por usuario |
|---|---|
| `logros(id, nombre, descripcion, condicion, xp)` | `usuario_logros(usuario_id, logro_id, estado, fecha)` |
| `accesorios(id, nombre, descripcion, costo, slot)` | `usuario_accesorios(usuario_id, accesorio_id, comprado, puesto)` |
| `metas(id, tag, descripcion, xp, dificultad, asignacion)` | `usuario_metas(usuario_id, meta_id, estado, progreso, periodo)` |
| `niveles(nivel, xp_requerida)` | *(el nivel se deriva de la xp)* |

Y a `usuarios` le faltará: `foto`, `hora_recordatorio`, `privacidad`, `experiencia_actual`, `nombre_mascota`.

Valores que seguirán **calculados** (no columnas): nivel, evolución de mascota, total de logros, obtenidos/en proceso/bloqueados, metas completadas, % de progreso, racha, promedios.

---

## 6. Reglas de oro (no romper)

1. **El contrato JSON no se cambia sin avisar** a P3 y P4.
2. **No guardar lo que se puede calcular** (puntuación, racha, promedios).
3. **Contraseñas siempre hasheadas** — nunca texto plano, nunca devolver el hash.
4. **Cada P trabaja en su rama** (`backend`, `flutter-ui`, `flutter-logica`) y se une a `main` al terminar.
5. **La lógica pura se prueba sola** — si tocás `funciones.py`, corré `test_funciones.py` antes de subir.

---

## 7. Estado y próximos pasos

| Pieza | Estado |
|---|---|
| Lógica pura de Python + tests | ✅ Hecho |
| Base de datos núcleo + datos de prueba | ✅ Hecho |
| Conexión Python ↔ MariaDB probada | ✅ Hecho |
| Flutter con pantallas (UI) | ✅ Hecho |
| **FastAPI (servidor responde JSON)** | ⏳ Siguiente |
| Flutter conecta a la Pi (HTTP real) | ⭕ Pendiente |
| Gamificación (7 tablas + lógica) | ⭕ Fase 2 |
| APK en los teléfonos | ⭕ Pendiente |

---

## Fuentes (documentación oficial usada para los ejemplos)

- FastAPI — cuerpo de petición con Pydantic, parámetros de ruta y CORS: https://fastapi.tiangolo.com
- Paquete `http` de Dart/Flutter — GET/POST y JSON: https://pub.dev/packages/http
