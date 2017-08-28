#!/usr/bin/env bash
set -eo pipefail; [[ $TRACE ]] && set -x

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

cat << EOF > "$HOME"/.drone.envars
DRONE_SERVER=${server}
DRONE_SECRET=${secret}
EOF

chmod 600 "$HOME"/.drone.envars

sudo docker run -d \
    --volume=/var/run/docker.sock:/var/run/docker.sock \
    --restart=always \
    --name=drone-agent \
    --env-file="$HOME"/.drone.envars \
    drone/agent:latest
