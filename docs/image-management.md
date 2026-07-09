
# Gestión de la biblioteca de imágenes

Ahora mismo, la biblioteca de imágenes está gestionada utilizando [digiKam](https://www.digikam.org/). Los propios archivos de imagen y los metadatos viven en bases de datos diferentes; las fotos permanecen tal y como llegan, inalteradas. Con digiKam se hace la gestión de las fechas, etiquetas, caras y otras visualizaciones, como filtrados por lugar, fecha o personas.

Para exponer esta biblioteca al acceso remoto se usará [immich](https://immich.app); no realiza ningún tipo de gestión, sólo permite el acceso y el streaming de la biblioteca desde la red. También tiene las características de búsqueda y filtrado avanzadas y visualización de metadatos. Lo importante es que parece que sí puede compatibilizarse con la actual biblioteca de digiKam.

En otras palabras, digiKam actúa como la herramienta de organización, edición y catalogado, e immich es el portal de visualización web/móvil. La compatibilización ocurre por medio de la lectura de los archivos sidecar `.xmp` que digiKam debe crear y gestionar. La propia biblioteca es sólo de lectura para immich.

De esta forma se separa el almacenamiento de los datos con su propia manipulación y gestión; los datos siempre viven por su cuenta inalterables.

## Configuración

En los ajustes de digiKam, Metadatos > Archivos anexos, selecciona escribir en archivos anexos (Escribir sólo en anexo XMP), y compatibilizar los nombres con programas comerciales. Los archivos XMP se escriben junto a los archivos de imagen por estándar de la industria, que metadatos y datos vivan juntos y no queden huérfanos.
