
# Tailscale service

El primero y servicio más básico, para acceder con el nombre del dispositivo (MagicDNS) y desde cualquier parte conectado a la tailnet.

Para una configuración headless, es necesario proveer a Tailscale con una key de autentificación, `$TS_AUTHKEY`. Este es el único parámetro que necesita para conectar la máquina tal y como lo hace la aplicación de escritorio. Esto ocurre una única vez, y se almacena en el estado de tailscale. Asegúrate de que la key no está caducada, por defecto tienen un sulo uso.

Información y documentación sobre cómo utilizar este contenedor y su configuración puede encontrarse en la [documentación de Tailscale](https://tailscale.com/docs/features/containers/docker/how-to/connect-docker-container).
