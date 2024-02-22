# K8 Snapshot Tool

## Descripción

El script `k8_snapshot.sh` está diseñado para proporcionar una radiografía completa de los recursos de Kubernetes en un cluster, capturando la configuración de recursos clave como pods, services, deployments, y más. Desarrollado por Orion, este script facilita el diagnóstico de clusters al generar un archivo comprimido que contiene la configuración de los recursos y los eventos de cada namespace.

## Características

- Captura configuraciones de múltiples tipos de recursos de Kubernetes.
- Genera un archivo comprimido con la fecha actual, nombrado como "ClusterSnapshot_Orion_yyyy-MM-dd.zip".
- Facilita el diagnóstico de clusters proporcionando una instantánea detallada de su estado actual.

## Requisitos Previos

Para utilizar este script, necesitas tener instalado y configurado lo siguiente:

- `kubectl`: Debe estar configurado para comunicarse con tu cluster de Kubernetes.
- `zip`: Necesario para comprimir el directorio de salida en un archivo .zip.

## Uso

1. **Descargar el Script** : Primero, descarga el script `k8_snapshot.sh` en tu máquina local o servidor que tiene acceso al cluster de Kubernetes.

```sh
wget https://raw.githubusercontent.com/orion-global/utils/k8-snapshot-tool/main/k8_snapshot.sh -O k8_snapshot.sh
```

2. **Hacer el Script Ejecutable** :
   Ejecuta el siguiente comando para hacer el script ejecutable:

```sh
chmod +x k8_snapshot.sh
```

3. **Ejecutar el Script** :
   Ahora, puedes ejecutar el script utilizando el siguiente comando:

```sh
./k8_snapshot.sh
```

El script comenzará a recopilar la configuración de los recursos y eventos de todos los namespaces en tu cluster de Kubernetes.

4. **Recuperar el Archivo Comprimido** :
   Una vez completada la ejecución del script, se generará un archivo .zip en el directorio actual, nombrado siguiendo el formato "ClusterSnapshot_Orion_yyyy-MM-dd.zip". Puedes utilizar este archivo para revisar la configuración y los eventos de tu cluster.

## Notas Adicionales

- Asegúrate de tener los permisos necesarios para acceder a los recursos del cluster de Kubernetes.
- El tiempo de ejecución del script puede variar dependiendo del tamaño de tu cluster y la cantidad de recursos presentes.
