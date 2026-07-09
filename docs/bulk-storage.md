
El almacenamiento grande en caliente será una pool de discos locales gestionados por el sistema de archivos btrfs. Esto no incluye la gestión de copias de seguridad.

Los principales motivos para la elección de btrfs son los snapshots, la compresión transparente a nivel de subvolumen (la deduplicación requiere herramientas externas) y la posibilidad de crear una pool de almacenamiento sobre la que añadir y retirar discos "en caliente".

## Preparar btrfs y compresión

El proceso es bastante sencillo: formatear los discos con btrfs y luego montarlos con opciones, como RAID o compresión, para utilizarlos.

## Hacer o no hacer la deduplicación

btrfs admite hacer deduplicación de bloques en el disco. Teniendo en cuenta que se va aplicar sobre datos generales (imágenes, vídeos, roms, documentos...) y en una pool de discos mecánicos de distintas características, ¿merece la pena aplicar deduplicación a los datos? 

Además, son necesarias herramientas externas como `bees` o `duperemove` para aplicar la deduplicación sobre los datos. Una vez los datos están deduplicados, no es necesario que las herramientas estén disponibles; se explota una característica del kernel de modo que varios archivos puedan compartir un único bloque en el disco, los archivos apuntan al mismo bloque. A la hora de leer el archivo, el propio kernel se encarga de ello; la deduplicación es un estado del sistema de archivos. Las herramientas sólo se necesitan para encontrar duplicados y ejecutar la fusión.

Sin embargo, esto supone una fragmentación que puede ser enorme, y va a impactar en el rendimiento de los discos mecánicos. Ahora mismo, el cuello de botella sería la red, pero es algo a tener en cuenta. Además, intentar hacer desfragmentación rompe los enlaces y la propia deduplicación; **destruye los datos**.

No es tanto un problema en discos mecánicos, pero los SSDs sufren más con cada escritura, y la deduplicación aplica más escritura que la presentada.

Además, el deduplicado sobre archivos multimedia no es eficiente, igual que para la compresión.

Al comparar esto con simple compresión, la fragmentación es mucho menor, se leen menos datos del disco y el tiempo pasa a CPU en descompresión (puede mejorar la velocidad de lectura), e igual para la escritura; no intenta comprimir archivos incompresibles, como fotos (la compresión ya está aplicada por el algoritmo, como JPEG); y no hay amplificación en la escritura, no hay compartición adicional.

Es decir, que probablemente la deduplicación no es algo que convenga aplicar a todo el disco general, como si haría con la compresión. Quizá es algo que reservar para cosas como backups, donde no se va a leer ni interactuar en él con frecuencia.

## Partición btrfs

Ahora mismo, estoy con mica, y tiene el disco mecánico de 500 GB pequeño de forma interna. Éste será la primera plataforma para la carpeta de contenido personal e irrecuperable. Vamos a configurarlo como primer punto en la nube para empezar a trasladar datos.

Este primer traslado de datos incluirá:

- Acceso en local como disco remoto (disco SMB e interfaz web).
- Copias de seguridad automáticas y snapshots de los datos (política de seguridad de datos).
- ¿Sincronización entre dispositivos? Trabajar con estos archivos.
  - DigiKam
  - Documentos
  - Proyectos y repositorios
  - Documentación de formación y vault
  - ¿Otros datos, como contabilidad o las contraseñas?

Esto parece que ha crecido lo suficiente como para considerarse su propio subproyecto.
