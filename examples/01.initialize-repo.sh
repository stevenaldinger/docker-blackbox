#!/bin/sh

docker exec -it blackbox blackbox_initialize

docker exec -it blackbox bash -c "git commit -m'INITIALIZE BLACKBOX' .blackbox /repo/.gitignore"

exit 0
