"""Lógica pura de Bunwe: sueño + auth. Sin BD, sin red — se prueba sola."""
from datetime import datetime, date, timedelta
import hashlib
import secrets


# ---------- Sueño ----------

def horas_dormidas(acostarse, despertar):
    """Horas entre dos "HH:MM". Cruza medianoche si despertar <= acostarse."""
    fmt = "%H:%M"
    a = datetime.strptime(acostarse, fmt)
    d = datetime.strptime(despertar, fmt)
    if d <= a:
        d += timedelta(days=1)
    return round((d - a).total_seconds() / 3600, 2)


def calcular_puntuacion(horas, meta):
    """(puntuacion 0-100, mensaje|None). Tope 100, nunca resta."""
    puntuacion = round(min(horas / meta, 1) * 100)
    mensaje = "Dormir de más también puede ser contraproducente" if horas > meta else None
    return puntuacion, mensaje


def cumplio_meta(horas, meta):
    # ponytail: umbral exacto; si querés tolerancia -> horas >= meta - 0.25
    return horas >= meta


def calcular_racha(fechas_cumplidas, hasta=None):
    """Días consecutivos cumplidos que terminan en `hasta`.
    `hasta` default = la fecha cumplida más reciente (la última noche registrada).
    Si `hasta` no está entre las cumplidas, la racha es 0 (se rompió).
    Fechas: date o "YYYY-MM-DD".
    ponytail: ancla a la última noche registrada, no al reloj de hoy — testeable y sin clock."""
    cumplidas = {_a_date(f) for f in fechas_cumplidas}
    if not cumplidas:
        return 0
    dia = _a_date(hasta) if hasta else max(cumplidas)
    racha = 0
    while dia in cumplidas:
        racha += 1
        dia -= timedelta(days=1)
    return racha


def armar_respuesta(registros, meta):
    """registros: lista de {"fecha","acostarse","despertar"}. Devuelve el JSON del contrato."""
    if not registros:
        return {"puntuacion": 0, "horas": 0, "racha_dias": 0,
                "ultima_noche": None, "historial": []}

    noches = [{"fecha": _a_date(r["fecha"]),
               "horas": horas_dormidas(r["acostarse"], r["despertar"])}
              for r in registros]
    noches.sort(key=lambda n: n["fecha"])

    ultima = noches[-1]
    puntuacion, _ = calcular_puntuacion(ultima["horas"], meta)
    cumplidas = [n["fecha"] for n in noches if cumplio_meta(n["horas"], meta)]
    dias_es = ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"]

    return {
        "puntuacion": puntuacion,
        "horas": ultima["horas"],
        "racha_dias": calcular_racha(cumplidas, hasta=ultima["fecha"]),
        "ultima_noche": ultima["fecha"].isoformat(),
        "historial": [{"dia": dias_es[n["fecha"].weekday()], "horas": n["horas"]}
                      for n in noches],
    }


def _a_date(f):
    return f if isinstance(f, date) else datetime.strptime(f, "%Y-%m-%d").date()


# ---------- Auth ----------

_ITER = 200_000  # ponytail: pbkdf2 stdlib; subir iteraciones o pasar a argon2 si hace falta


def hashear_password(password):
    """Devuelve "pbkdf2_sha256$iter$salt$hash". Salt aleatorio por usuario."""
    salt = secrets.token_bytes(16)
    h = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, _ITER)
    return f"pbkdf2_sha256${_ITER}${salt.hex()}${h.hex()}"


def verificar_password(password, guardado):
    """Compara en tiempo constante. False si el formato no cuadra."""
    try:
        _algo, iteraciones, salt_hex, hash_hex = guardado.split("$")
        h = hashlib.pbkdf2_hmac("sha256", password.encode(),
                                bytes.fromhex(salt_hex), int(iteraciones))
        return secrets.compare_digest(h.hex(), hash_hex)
    except (ValueError, AttributeError):
        return False
