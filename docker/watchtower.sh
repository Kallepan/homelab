#!/bin/bash
docker run -it -d \
    --name WatchTower \
    --restart unless-stopped \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower \
    --cleanup \
    --include-restarting \
    --rolling-restart \
    --include-stopped \
    --interval 21600
