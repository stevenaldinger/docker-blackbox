#!/bin/sh

secret_password=""

create_secret_password () {
  if [ "$(uname -s)" == "Darwin" ]
  then
    secret_password="$(date +%s | shasum | base64 | head -c 32)"
  else
    secret_password="$(date +%s | sha256sum | base64 | head -c 32)"
  fi
}

create_secret_password

docker exec -it blackbox bash -c "\
  cat > .env <<EOF
admin_password='$secret_password'
EOF
"

docker exec -it blackbox bash -c "\
  . /root/.bashrc; \
  start_gpg_agent; \
  blackbox_register_new_file .env
"

exit 0
