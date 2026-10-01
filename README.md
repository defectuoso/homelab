
# Homelab

Propósitos del homelab:

1. Aprender y experimentar
2. Infra de servicios personales reales
3. Proyecto de portfolio

## Principios y filosofía

El homelab consiste de una única máquina de cuatro núcleos de bajo consumo. Busco mantener el host lo más minimalista posible, tanto por longevidad como por mantenimiento, así que básicamente todo lo que no sea Debian y Docker vive en contenedores. Si algo se rompe será en el contenedor, y no afectará a otros servicios. Además, cada servicio podrá eliminarse sin dejar rastro. Se busca mantener una filosofía [KISS](https://es.wikipedia.org/wiki/Principio_KISS) para que sea sencillo de entender y recordar.

El repositorio es la fuente de verdad. Los cambios se raelizan sobre él, y luego se sincroniza en el servidor. La documentación es parte del trabajo, tanto para terceros como para mí, cuando lo olvide.

El estado actual de la máquina puede comprobarse en [[STATE.md]].

## Guía de uso

### Gestión de secretos

Los secretos se manejan con SOPS. La clave privada para desencriptar los secretos vive fuera del repositorio y del entorno de trabajo, en la ubicación estándar en `.config`, que SOPS lee por defecto. Se utilizan scripts para desplegar los servicios, que cargan los secretos como variables de entorno para los contenedores.

### Añadir servicios

Todo lo que un servicio necesite está contenido en su propia. Logs y otros datos persistentes del servicio, están almacenados en el subvol del pool `@services` (p. ej., `@services/tailscale/`, que está montado en `/srv/services/tailscale`).
