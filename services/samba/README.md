
# Samba

Servidor de ficheros SMB para los shares `nimbo` (nube personal) y la biblioteca; otros shares pueden ser introducidos por medio del archivo de configuración `smb.conf`, en `/srv/services/samba`, y la gestión de usuarios ocurre por medio del `users.conf` en la misma ubicación. Se utiliza el contenedor [dockur/samba](https://github.com/dockur/samba): ligero (Alpine).

Al igual que con syncthing, los volúmenes de Docker son montados en un `compose.override.yaml` ignorado por git.

Por la configuración del compose, se expone el directorio `/srv/nimbo`. Como [Tailscale](./../tailscale/README.md) corre en modo host, el puerto 445 del host también es alcanzable desde la tailnet, así que el share es accesible desde cualquier sitio:

- Windows: `\\mica\nimbo` (MagicDNS), o `\\<ip>\nimbo` en la LAN.
- macOS / Linux: `smb://mica/nimbo`.
