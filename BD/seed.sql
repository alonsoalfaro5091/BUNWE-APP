-- Bunwe — datos ficticios para probar. Correr DESPUES de schema.sql.
-- Usuario de prueba: ana / clave123  (hash pbkdf2 real, login funciona)

INSERT INTO usuarios (nombre, password_hash, meta_horas, monedas) VALUES
('ana', 'pbkdf2_sha256$200000$59f6e491fa35f520f0f58380073bb67e$160ae751d13e517c6bba968d995705de759c037817a35e8a688b60991b14e80d', 8.0, 0);

-- 14 noches de ana (id 1). horas ya calculadas.
INSERT INTO noches (usuario_id, fecha, hora_acostarse, hora_despertar, horas) VALUES
(1, '2026-06-18', '23:15', '07:00', 7.75),
(1, '2026-06-19', '23:45', '06:30', 6.75),
(1, '2026-06-20', '22:30', '08:00', 9.50),
(1, '2026-06-21', '22:30', '07:15', 8.75),
(1, '2026-06-22', '00:15', '06:30', 6.25),
(1, '2026-06-23', '00:15', '07:00', 6.75),
(1, '2026-06-24', '22:30', '06:30', 8.00),
(1, '2026-06-25', '23:45', '07:30', 7.75),
(1, '2026-06-26', '22:30', '07:00', 8.50),
(1, '2026-06-27', '22:30', '08:00', 9.50),
(1, '2026-06-28', '23:45', '06:30', 6.75),
(1, '2026-06-29', '00:15', '06:30', 6.25),
(1, '2026-06-30', '23:00', '08:00', 9.00),
(1, '2026-07-01', '22:30', '08:00', 9.50);
