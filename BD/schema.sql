-- Bunwe — esquema MariaDB. Sale del contrato JSON + la lógica.
-- puntuacion y cumplio NO se guardan: se calculan al leer (triviales desde horas + meta).

CREATE TABLE usuarios (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(50)  NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,          -- "pbkdf2_sha256$iter$salt$hash", nunca texto plano
  meta_horas    DECIMAL(3,1) NOT NULL DEFAULT 8.0,
  monedas       INT NOT NULL DEFAULT 0           -- saldo para la tienda de accesorios
);

CREATE TABLE noches (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id     INT  NOT NULL,
  fecha          DATE NOT NULL,
  hora_acostarse TIME NOT NULL,
  hora_despertar TIME NOT NULL,
  horas          DECIMAL(4,2) NOT NULL,          -- calculado al guardar
  UNIQUE (usuario_id, fecha),                    -- una noche por día por usuario
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
