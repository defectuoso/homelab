
if ! test -d "/srv/services/syncthing"; then
    echo "Directory 'services/syncthing/' does not exists or it's not reachable. Aborting..."
    exit 1
else
    echo "Using already existant 'services/syncthing/' directory"
fi

docker compose up -d
