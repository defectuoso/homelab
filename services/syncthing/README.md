
Syncthing's docker docs can be found [here](https://github.com/syncthing/syncthing/blob/main/README-Docker.md).

This servie uses `compose.override.yaml` in the host to specify bind mounts and to not expose internal file trees in the repo. An example of such an override would be

```yaml
services:
  syncthing:
    volumes:
      - /home/user/somedir:/var/syncthing/somedir
```

The GUI's default port is 8384.
