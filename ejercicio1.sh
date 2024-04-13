#!/bin/bash

# Verificar que se proporciona un argumento
if [ $# -ne 1 ]; then
    echo "Usage: $0 <process_id>"
    exit 1
fi

# Obtener la información del proceso
process_id=$1
process_info=$(ps -p $process_id -o comm=,pid=,ppid=,user=,pcpu=,pmem=,stat= --no-headers)
process_name=$(echo $process_info | awk '{print $1}')
pid=$(echo $process_info | awk '{print $2}')
ppid=$(echo $process_info | awk '{print $3}')
user=$(echo $process_info | awk '{print $4}')
cpu_usage=$(echo $process_info | awk '{print $5}')
memory_usage=$(echo $process_info | awk '{print $6}')
status=$(echo $process_info | awk '{print $7}')
executable_path=$(readlink -f /proc/$process_id/exe)

# Mostrar la información
echo "Nombre del proceso: $process_name"
echo "ID del proceso: $pid"
echo "Parent process ID: $ppid"
echo "Usuario propietario: $user"
echo "Porcentaje de uso de CPU: $cpu_usage%"
echo "Consumo de memoria: $memory_usage"
echo "Estado: $status"
echo "Path del ejecutable: $executable_path"
