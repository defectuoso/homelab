
# Homelab

Propósitos del homelab:

1. Aprender y experimentar
2. Infra de servicios personales reales
3. Proyecto de portfolio

## Principios y filosofía

El homelab consiste de una única máquina de cuatro núcleos de bajo consumo. Busco mantener el host lo más minimalista posible, tanto por longevidad como por mantenimiento, así que básicamente todo lo que no sea Debian y Docker vive en contenedores. Si algo se rompe será en el contenedor, y no afectará a otros servicios. Además, cada servicio podrá eliminarse sin dejar rastro. Se busca mantener una filosofía [KISS](https://es.wikipedia.org/wiki/Principio_KISS) para que sea sencillo de entender y recordar.

El repositorio es la fuente de verdad. Los cambios se raelizan sobre él, y luego se sincroniza en el servidor. La documentación es parte del trabajo, tanto para terceros como para mí, cuando lo olvide.

## Guía de uso

### Gestión de secretos

Los secretos se manejan con SOPS. La clave privada para desencriptar los secretos vive fuera del repositorio y del entorno de trabajo, en la ubicación estándar en `.config`, que SOPS lee por defecto. Se utilizan scripts para desplegar los servicios, que cargan los secretos como variables de entorno para los contenedores.

### Copias de seguridad y recuperación

TODO

- Copias de seguridad de Nimbo
- Copias de los archivos de configuración (`/srv/services`).

### Añadir servicios

Todo lo que un servicio necesite está contenido en su propia. Logs y otros datos persistentes del servicio, están almacenados en el subvol del pool `@services` (p. ej., `@services/tailscale/`, que está montado en `/srv/services/tailscale`).

Los cambios se realizan en una máquina de desarrollo, donde hacen push al remote del que lee el homelab. El directorio de producción en el homelab siempre permanece en `main`, así que al sincronizar los cambios para probarlos, se hacen en una rama y worktree propios. La rama se introduce en `main` como un único commit con squash.

Se deben tener en cuenta durante las pruebas las posibles colisiones con producción.

Se expone un procedimiento de ejemplo para introducir un nuevo servicio *newserv*.

```bash
# En una máquina de desarrollo

git clone https://github.com/defectuoso/homelab # clona el repo, .git y working tree; crea origin y la vinculación con main
cd homelab/
git swith main # por si acado, ya debería estar en main
git pull # sincroniza commits del remote en local

git switch -n newserv
git branch -a # verificación

# Se hacen los cambios y se push a origin
git add .
git commit -m "newserv: status message"
git push -u origin newserv
```

Una vez se tiene una primera versión, en la máquina de producción se sincronizan los cambios y se prueban en un nuevo worktree.

```bash
# En la máquina de producción
cd ~/homelab
git fetch
git worktree add ../homelab-test newserv

cd ../homelab-test
# Se prueba e itera el servicio
git pull # Sincroniza cambios pusheados desde máquina de desarrollo
bash deploy.sh
# ...
```

Una vez satisfecho con el servicio, los cambios se introducen en producción como un único commit por un merge squash.

```bash
# En la máquina de desarrollo
git switch main
git pull # Asegurar main actualizado
git merge --squash newserv
git commit -m "new service: newserv"
git push
```

Al hacer `git pull` en el directorio de producción, se actualizará con el nuevo servicio.

Por último queda hacer limpieza. Borrar las ramas es la práctica estándar, ya que no suele aportar información útil. En caso contrario y sí resulta informativa, es mejor dejarla etiquetada.

```bash
# Aún en homelab-test/
docker compose down
cd ../homelab
git worktree remove ../homelab-test
git branch -D newserv # efectivamente, borrar la rama local
git push origin --delete newserv # borra la rama en origin
```
