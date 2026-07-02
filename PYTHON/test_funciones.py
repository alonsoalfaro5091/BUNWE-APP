"""Chequeos con assert. Correr desde PYTHON/:  python test_funciones.py"""
from funciones.funciones import (
    horas_dormidas, calcular_puntuacion, cumplio_meta,
    calcular_racha, armar_respuesta, hashear_password, verificar_password,
)

# horas_dormidas: cruce de medianoche y mismo día
assert horas_dormidas("23:30", "07:00") == 7.5
assert horas_dormidas("22:00", "06:30") == 8.5
assert horas_dormidas("01:00", "09:15") == 8.25

# puntuacion: tope 100, no penaliza de más, mensaje al pasarse
assert calcular_puntuacion(7.5, 8) == (94, None)
assert calcular_puntuacion(8, 8) == (100, None)
p, m = calcular_puntuacion(9, 8)
assert p == 100 and m is not None
assert calcular_puntuacion(4, 8) == (50, None)

# cumplio_meta
assert cumplio_meta(8, 8) and not cumplio_meta(7.9, 8)

# racha: consecutivos hasta la última; se rompe con un hueco
assert calcular_racha(["2025-06-10", "2025-06-09", "2025-06-08"]) == 3
assert calcular_racha(["2025-06-10", "2025-06-08", "2025-06-07"]) == 1
assert calcular_racha([]) == 0

# armar_respuesta: contrato completo. Última noche no cumple -> racha 0
reg = [
    {"fecha": "2025-06-08", "acostarse": "23:00", "despertar": "07:00"},  # 8.0 cumple
    {"fecha": "2025-06-09", "acostarse": "23:30", "despertar": "07:30"},  # 8.0 cumple
    {"fecha": "2025-06-10", "acostarse": "00:00", "despertar": "06:00"},  # 6.0 no
]
r = armar_respuesta(reg, meta=8)
assert r["horas"] == 6.0
assert r["ultima_noche"] == "2025-06-10"
assert r["racha_dias"] == 0
assert len(r["historial"]) == 3
assert armar_respuesta([], 8)["puntuacion"] == 0

# racha viva: si la última sí cumple, cuenta hacia atrás
reg2 = [
    {"fecha": "2025-06-08", "acostarse": "23:00", "despertar": "07:00"},
    {"fecha": "2025-06-09", "acostarse": "23:00", "despertar": "07:00"},
]
assert armar_respuesta(reg2, meta=8)["racha_dias"] == 2

# auth: verifica bien, rechaza mal, salt aleatorio, formato inválido
h = hashear_password("clave123")
assert verificar_password("clave123", h)
assert not verificar_password("otra", h)
assert hashear_password("x") != hashear_password("x")
assert not verificar_password("x", "basura")

print("OK — todos los checks pasaron")
