#!/bin/sh

sensitive_file=".env.gpg"

docker exec -it blackbox bash -c "\
  . /root/.bashrc; \
  start_gpg_agent; \
  blackbox_cat $sensitive_file
"

exit 0
