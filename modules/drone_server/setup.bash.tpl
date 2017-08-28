#!/usr/bin/env bash
set -eo pipefail; [[ $TRACE ]] && set -x

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

cat << EOF > "$HOME"/.drone.envars
DRONE_HOST=http://${url}
DRONE_SECRET=${secret}
DRONE_OPEN=true
DRONE_GOGS=true
DRONE_GOGS_URL=http://gogs.drone.io
EOF

chmod 600 "$HOME"/.drone.envars

sudo docker run -d \
    --volume=/var/lib/drone:/var/lib/drone \
    -p 80:8000 \
    -p 9000:9000 \
    --restart=always \
    --name=drone-server \
    --env-file="$HOME"/.drone.envars \
    drone/drone:latest
