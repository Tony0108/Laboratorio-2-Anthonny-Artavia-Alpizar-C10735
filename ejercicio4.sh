#!/bin/bash

# Directorio que se escogio monitorear
directory="/var/log"

# Monitorear el directorio en busca de eventos de creación, modificación y eliminación
inotifywait -m -r -e create,modify,delete --format "%T %w %f %e" "$directory" |
while read date time directory file event; do
    echo "$date $time - $event: $file en $directory" >> /var/log/directory_changes.log
done

#Cuando se detecte un cambio, el script escribirá un mensaje de log en el archivo /var/log/directory_changes.log con la fecha y hora del cambio.

[Unit]
Description=Servicio de Monitoreo de Cambios en el Directorio /var/log
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash /ruta/al/directory_monitor.sh
WorkingDirectory=/ruta/al/directorio/del/script
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=multi-user.target

# Copiar el archivo de unidad de servicio a /etc/systemd/system/
sudo cp directory_monitor.service /etc/systemd/system/

# Recargar los archivos de configuración de systemd
sudo systemctl daemon-reload

# Se habilita el servicio para que se inicie en el arranque del sistema
sudo systemctl enable directory_monitor.service

# Se inicia el servicio
sudo systemctl start directory_monitor.service

# Se verifica el estado del servicio
sudo systemctl status directory_monitor.service
