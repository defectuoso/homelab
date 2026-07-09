
# Películas y series

La gestión de estos archivos está algo sometida a los patrones que utiliza [Jellyfin](https://jellyfin.org/), la aplicación utilizada para servirlos en streaming, y que requiere de un nombrado y estructura específicos en los archivos de películas y series.

## Patrón a utilizar para las carpetas de series y películas

Estas dos bibliotecas deben llamarse [`Movies/`](https://jellyfin.org/docs/general/server/media/movies) y [`Shows/`](https://jellyfin.org/docs/general/server/media/shows/), y pueden colocarse en cualquier punto del sistema de archivos.

Para el caso de las películas, cada una debe estar en su propia carpeta siguiendo el formato `Movie Name (year) [metadata provider id]`. Los campos `year` y `metadata provider id` son opcionales. Esta carpeta puede contener archivos auxiliares, como pistas de audio o subtítulos externos. Pueden incluso coexistir distintas versiones.
