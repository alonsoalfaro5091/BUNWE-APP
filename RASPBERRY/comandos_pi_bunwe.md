# 🍓 Comandos útiles — Raspberry Pi (BunweServer)

Referencia rápida de todo lo configurado hasta ahora. IP de Tailscale: `100.75.19.64`

---

## 🔌 Conexión

```bash
# Conectarte por SSH (sin password, autenticado vía Tailscale)
ssh faro@100.75.19.64

# Ver estado de tu red Tailscale (dispositivos conectados)
tailscale status

# Ver la IP de Tailscale de la Pi
tailscale ip -4
```

> Necesitas tener Tailscale corriendo en tu PC para poder conectarte.

---

## 🛡️ Firewall (ufw)

```bash
sudo ufw status verbose        # ver reglas activas
sudo ufw allow in on tailscale0  # permitir todo por Tailscale
sudo ufw delete allow OpenSSH  # (ya hecho) cerrar SSH a la red local
sudo ufw enable / disable      # activar o desactivar
```

---

## 🖥️ Sistema

```bash
sudo apt update && sudo apt upgrade -y   # actualizar paquetes
sudo apt autoremove -y                   # limpiar paquetes huérfanos
df -h                                    # espacio en disco (resumen)
sudo reboot                              # reiniciar
sudo shutdown -h now                     # apagar YA (recuerda: hay que desconectar el cable para volver a prenderla)
sudo shutdown -c                         # cancelar un apagado programado
htop                                     # monitor de procesos en vivo (q para salir)
ncdu /                                   # ver qué ocupa espacio, carpeta por carpeta (q para salir)
```

---

## 🗃️ MariaDB

```bash
sudo mariadb -u root -p                  # entrar al CLI
sudo systemctl status mariadb            # ver si está corriendo
sudo systemctl restart mariadb           # reiniciar (tras cambios de config)
```

Dentro del CLI de MariaDB:
```sql
SHOW DATABASES;
USE bunwe_app;
SHOW TABLES;
SELECT user, host FROM mysql.user;       -- ver usuarios y desde dónde pueden conectarse
SHOW GRANTS FOR 'faro'@'%';              -- ver permisos de un usuario
exit
```

**Conexión desde DBeaver (PC):**
- Host: `100.75.19.64` · Puerto: `3306` · Base: `bunwe_app` · Usuario: `faro`
- Requiere Tailscale activo en tu PC

**Backup manual:**
```bash
mysqldump -u faro -p bunwe_app > ~/backups/bunwe_$(date +%Y%m%d).sql
```

---

## ⚡ Servicio FastAPI (sleep-api)

```bash
sudo systemctl status sleep-api     # ver estado
sudo systemctl restart sleep-api    # reiniciar
sudo systemctl stop sleep-api       # detener
sudo systemctl start sleep-api      # iniciar
sudo journalctl -u sleep-api -n 50 --no-pager   # ver últimos 50 logs (errores, etc.)
sudo journalctl -u sleep-api -f     # seguir logs en vivo (Ctrl+C para salir)

# Editar el archivo del servicio
sudo nvim /etc/systemd/system/sleep-api.service
sudo systemctl daemon-reload        # aplicar cambios tras editar el .service
```

URL del API: `http://100.75.19.64:8000/docs` (documentación interactiva de FastAPI)

---

## 📊 Netdata (monitoreo)

```bash
sudo systemctl status netdata       # ver estado
sudo systemctl restart netdata      # reiniciar
```

Dashboard: `http://100.75.19.64:19999` (con Tailscale activo en tu PC — si aparece pantalla de "Trust URL", dale **Cancel** para ir al dashboard local clásico)

---

## 📝 Editor de texto (neovim)

```bash
sudo nvim /ruta/al/archivo
```
- `i` → entrar en modo inserción (escribir)
- `Esc` → salir de modo inserción
- `:wq` + Enter → guardar y salir
- `:q!` + Enter → salir sin guardar

---

## 🪟 Sesiones persistentes (tmux)

```bash
tmux new -s trabajo          # crear sesión llamada "trabajo"
# Ctrl+B, luego D            → desconectar sin matar la sesión
tmux attach -t trabajo       # reconectar a la sesión
tmux ls                      # ver sesiones activas
tmux kill-session -t trabajo # eliminar una sesión
```
Útil para dejar algo corriendo (backups largos, updates, pruebas) sin que se corte si se cae el SSH.

---

## 🐍 Entorno virtual Python (sleep-api)

```bash
cd ~/sleep-api
source venv/bin/activate     # activar antes de instalar paquetes o correr manualmente
uvicorn apiconfig:app --host 0.0.0.0 --port 8000 --reload   # correr en modo desarrollo (solo pruebas manuales)
deactivate                   # salir del entorno virtual
```

> En producción no hace falta correr esto a mano — el servicio `sleep-api` ya lo hace automáticamente al bootear la Pi.

---

## 🔑 Root / sudo

```bash
sudo passwd root             # definir contraseña de root (normalmente no la necesitas)
sudo comando                 # ejecutar cualquier comando con privilegios de administrador
```

> Casi nunca necesitas loguearte como root directamente — todo se maneja con `sudo` desde tu usuario `faro`.

---

## 📦 Estado general esperado (checklist rápido al conectarte)

```bash
sudo systemctl status sleep-api netdata mariadb tailscaled --no-pager
```
Los cuatro deberían mostrar `active (running)`.
