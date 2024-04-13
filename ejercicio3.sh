#!/bin/bash

# Verificar que se proporciona un argumento
if [ $# -ne 1 ]; then
    echo "Usage: $0 <executable>"
    exit 1
fi

executable=$1
log_file="process_monitor.log"
plot_file="process_monitor_plot.png"

# Función para monitorear el proceso y registrar el consumo de CPU y memoria
monitor_process() {
    while pgrep -x "$(basename $executable)" > /dev/null; do
        # Obtener el consumo de CPU y memoria del proceso
        cpu_usage=$(ps -p $(pgrep -x "$(basename $executable)") -o pcpu= --no-headers)
        memory_usage=$(ps -p $(pgrep -x "$(basename $executable)") -o pmem= --no-headers)
        # Registrar la información en el archivo de registro
        echo "$(date +"%Y-%m-%d %H:%M:%S") CPU: $cpu_usage% Memory: $memory_usage%" >> $log_file
        sleep 5  # Esperar 5 segundos antes de tomar la siguiente muestra
    done
}

# Ejecutar el proceso recibido como argumento
$executable &

# Iniciar el monitoreo del proceso en segundo plano
monitor_process &

# Esperar a que el proceso termine
wait $(pgrep -x "$(basename $executable)")

# Graficar los valores sobre el tiempo utilizando gnuplot
gnuplot <<- EOF
    set terminal png
    set output "$plot_file"
    set xlabel "Time"
    set ylabel "Usage (%)"
    set title "CPU and Memory Usage Over Time"
    plot "$log_file" using 1:3 with lines title "CPU", \
         "$log_file" using 1:5 with lines title "Memory"
EOF

echo "Grafico generado: $plot_file"
