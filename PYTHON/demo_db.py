"""Prueba end-to-end Python + MariaDB.
Antes: correr schema.sql y seed.sql en DBeaver, y editar CONFIG en funciones/llamada_db.py.
Correr desde PYTHON/:  python demo_db.py"""
import json
from funciones import llamada_db as db

print("== Login ==")
uid = db.login("ana", "clave123")
print("ana / clave123  ->", uid)
print("ana / mala      ->", db.login("ana", "mala"))
assert uid, "No encontré a ana. ¿Corriste seed.sql y editaste CONFIG?"

print("\n== Guardar noche de hoy ==")
horas = db.guardar_noche(uid, "2026-07-02", "23:00", "07:00")
print("horas calculadas:", horas)

print("\n== Historial (JSON del contrato) ==")
print(json.dumps(db.get_historial(uid), ensure_ascii=False, indent=2))
5
