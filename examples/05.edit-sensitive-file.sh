#!/bin/sh

sensitive_file=".env.gpg"

docker exec -it blackbox bash -c "\
  . /root/.bashrc; \
  start_gpg_agent; \
  blackbox_edit $sensitive_file
"

docker exec -it blackbox bash -c "\
  git commit -m"$sensitive_file updated" "$sensitive_file"
"

exit 0
