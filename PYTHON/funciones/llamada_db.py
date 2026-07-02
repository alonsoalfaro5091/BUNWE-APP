"""Conexión a MariaDB + consultas. Usa las funciones puras de funciones.py.
Requiere: pip install pymysql
Editá CONFIG con los datos de TU base (local o la Pi) antes de correr."""
import pymysql
from pymysql.cursors import DictCursor

from funciones.funciones import (
    horas_dormidas, armar_respuesta, hashear_password, verificar_password,
)

# ---- Editá esto ----
CONFIG = {
    "host": "100.75.19.64",
    "user": "sleep_user",
    "password": "faro_bunwe2026",
    "database": "bunwe_app",
    "cursorclass": DictCursor,
    "autocommit": True,
}


def conectar():
    return pymysql.connect(**CONFIG)


# ---- Usuarios / auth ----

def crear_usuario(nombre, password, meta_horas=8.0):
    """Crea usuario con contraseña hasheada. Devuelve el id nuevo."""
    with conectar() as con, con.cursor() as cur:
        cur.execute(
            "INSERT INTO usuarios (nombre, password_hash, meta_horas) VALUES (%s,%s,%s)",
            (nombre, hashear_password(password), meta_horas),
        )
        return cur.lastrowid


def login(nombre, password):
    """Devuelve el id del usuario si la contraseña es correcta, si no None."""
    with conectar() as con, con.cursor() as cur:
        cur.execute("SELECT id, password_hash FROM usuarios WHERE nombre=%s", (nombre,))
        u = cur.fetchone()
    if u and verificar_password(password, u["password_hash"]):
        return u["id"]
    return None


# ---- Noches ----

def guardar_noche(usuario_id, fecha, acostarse, despertar):
    """Calcula las horas e inserta la noche. Si ya existe esa fecha, la actualiza."""
    horas = horas_dormidas(acostarse, despertar)
    with conectar() as con, con.cursor() as cur:
        cur.execute(
            "INSERT INTO noches (usuario_id, fecha, hora_acostarse, hora_despertar, horas) "
            "VALUES (%s,%s,%s,%s,%s) "
            "ON DUPLICATE KEY UPDATE hora_acostarse=VALUES(hora_acostarse), "
            "hora_despertar=VALUES(hora_despertar), horas=VALUES(horas)",
            (usuario_id, fecha, acostarse, despertar, horas),
        )
    return horas


def get_historial(usuario_id):
    """Lee las noches + la meta del usuario y arma el JSON del contrato."""
    with conectar() as con, con.cursor() as cur:
        cur.execute("SELECT meta_horas FROM usuarios WHERE id=%s", (usuario_id,))
        u = cur.fetchone()
        if not u:
            return None
        cur.execute(
            "SELECT fecha, "
            "TIME_FORMAT(hora_acostarse,'%%H:%%i') AS acostarse, "
            "TIME_FORMAT(hora_despertar,'%%H:%%i') AS despertar "
            "FROM noches WHERE usuario_id=%s ORDER BY fecha",
            (usuario_id,),
        )
        registros = cur.fetchall()
    return armar_respuesta(registros, float(u["meta_horas"]))
