
# Samba

Servidor de ficheros SMB para el share `nimbo` (mi nube personal). En el host, `/srv/nimbo` es el subvolumen del pool de almacenamiento. Se utiliza el contenedor [dockur/samba](https://github.com/dockur/samba): ligero (Alpine) y con una configuración mínima por variables de entorno.

Por la configuración del compose, se expone el directorio `/srv/nimbo`. Como [Tailscale](./../tailscale/README.md) corre en modo host, el puerto 445 del host también es alcanzable desde la tailnet, así que el share es accesible desde cualquier sitio:

- Windows: `\\mica\nimbo` (MagicDNS), o `\\<ip>\nimbo` en la LAN.
- macOS / Linux: `smb://mica/nimbo`.
