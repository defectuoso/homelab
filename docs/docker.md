
# How the homelab uses Docker

## `compose/` directory

This subdirectory contains the definitions for each service running in the server. Each service is a subdir in `compose/`. So we get something like, as example,
```
compose/
  nginx/
    compose.yml
    nginx.conf
  paperless/
    compose.yml
    .env
  monitoring/
    compose.yml       ← prometheus + grafana together, one logical unit
```

When using `docker compose up` from inside a directory, Docker derives the project name from the dir name. This name is what it's used for groups and namespaces resources belonging to a service.

## Day-to-day 

```bash
cd compose/paperless

docker compose up -d          # start in background
docker compose down           # stop and remove containers, keep volumes
docker compose down -v        # stop and remove containers AND volumes (destructive)

docker compose logs -f        # follow logs (all services)
docker compose logs -f app    # follow logs (one service)

docker compose ps             # status of this project's containers
docker compose pull           # pull new image versions (doesn't restart anything)
docker compose up -d          # after pull: recreates containers that have new images

docker compose exec app bash  # get a shell inside a running container
```

## Other rules

- For robustness, pin image versions, do not use `latest` for images; avoid automatic breaking changes. Updates should be included in the maintenance process.
- Named volumes over bind mounts for data, so Docker manages them and survive container recreation. Bind mounts are to use direct filesystem access from the host, like exports, configs edited by hand.
- Bind ports to localhost only, `"127.0.0.1:8000:8000"` instead of `"8000:8000"`, to reach the service only from the machine and not the local network.
- `restart: unless-stopped`, to survive after reboot.
- Keep secrets in `.env` file, not the compose.

## Maintenance

```bash
# Clean stopped containers, dangling images, unused networks, build cache
docker system prune -f
# Remove unused images
docker image prune -a -f
```
