#!/bin/bash
echo $BASH_VERSION

# Fecha actual en formato yyyy-MM-dd
TODAY=$(date +%F)

# Directorio base
BASE_DIR="./ClusterSnapshot_Orion_${TODAY}"

SNAPSHOT_NAME="ClusterSnapshot_Orion_${TODAY}.zip"

# Crear el directorio base si no existe
mkdir -p "$BASE_DIR"

# Tipos de recursos para descargar
resource_types=("pods" "services" "deployments" "daemonsets" "statefulsets" "configmap" "persistentvolumeclaims" "resourcequotas" "limitranges" "jobs" "cronjobs" "ingress")

# Obtener todos los namespaces
namespaces=$(kubectl get ns -o jsonpath="{.items[*].metadata.name}")

# # Iterar sobre cada namespace
for ns in $namespaces; do
    echo "Descargando configuraciones para el namespace: $ns"

    # Crear directorio para el namespace
    ns_dir="${BASE_DIR}/${ns}"
    mkdir -p $ns_dir

    # Iterar sobre cada tipo de recurso
    for resource in "${resource_types[@]}"; do
        echo "  Descargando recursos de tipo $resource"

        # Crear directorio para el tipo de recurso
        resource_dir="${ns_dir}/${resource}"
        mkdir -p $resource_dir

        # Obtener los nombres de los recursos del tipo actual
        resources=$(kubectl get $resource -n $ns -o jsonpath="{.items[*].metadata.name}")

        # Descargar la configuración de cada recurso
        for r in $resources; do
            kubectl get $resource $r -n $ns -o yaml > "${resource_dir}/${r}.yaml"
        done
    done

    # Descargar eventos para el namespace actual
    echo "  Descargando eventos"
    kubectl get events -n $ns -o yaml > "${ns_dir}/events.yaml"
    kubectl get all -n $ns > "${ns_dir}/summary.txt"
    kubectl top pod -n $ns --sum=true > "${ns_dir}/top-summary.txt"
done

echo "Descarga completa."

# Generar un archivo de resumen con la cantidad de archivos por recurso y namespace
kubectl top node --show-capacity=true > "${BASE_DIR}/top-summary.txt"
summary_file="${BASE_DIR}/summary.txt"
echo "Generando resumen de configuraciones..." > "$summary_file"

touch "$summary_file"
# Iterar sobre cada directorio de namespace
for ns_dir in ${BASE_DIR}/*; do
    if [[ -d "$ns_dir" ]]; then
        ns=$(basename "$ns_dir")
        echo "Namespace: $ns" >> "$summary_file"
        # Iterar sobre cada directorio de tipo de recurso dentro del namespace
        for resource_dir in ${ns_dir}/*; do
            if [[ -d "$resource_dir" ]]; then
                resource=$(basename "$resource_dir")
                count=$(find "$resource_dir" -type f -name "*.yaml" | wc -l)
                echo "  $resource: " >> "$summary_file"
                echo "$count files" >> "$summary_file"
            fi
        done
        echo "" >> "$summary_file" # Añadir una línea en blanco para separar los namespaces
    fi
done

echo "Resumen de configuraciones generado en $summary_file."

# Comprimir el directorio BASE_DIR en el archivo SNAPSHOT_NAME
zip -r "${SNAPSHOT_NAME}" "${BASE_DIR}"

echo "Archivo de snapshot generado: ${SNAPSHOT_NAME}"