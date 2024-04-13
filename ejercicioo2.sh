#!/bin/bash

# Verificar que se proporcionan los argumentos necesarios
if [ $# -ne 2 ]; then
    echo "Usage: $0 <process_name> <command_to_execute>"
    exit 1
fi

process_name=$1
command_to_execute=$2

# Función para verificar y levantar el proceso si es necesario
monitor_process() {
    while true; do
        # Verificar si el proceso está en ejecución
        if ! pgrep -x "$process_name" > /dev/null; then
            echo "El proceso '$process_name' no está en ejecución. Iniciando el proceso..."
            # Ejecutar el comando para iniciar el proceso
            $command_to_execute &
        fi
        sleep 5  # Esperar 5 segundos antes de verificar nuevamente
    done
}

# Ejecutar la función de monitoreo en segundo plano
monitor_process &
