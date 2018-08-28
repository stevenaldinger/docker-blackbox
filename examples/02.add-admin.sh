#!/bin/sh

if [ -z "${GPG_KEY_EMAIL_ADDRESS}" ]
then
  echo "You need to set the 'GPG_KEY_EMAIL_ADDRESS' \
        environment variable to run this script."
  exit 1
fi

docker exec -it blackbox bash -c "\
  . /root/.bashrc; \
  start_gpg_agent; \
  blackbox_addadmin $GPG_KEY_EMAIL_ADDRESS\
"

docker exec -it blackbox bash -c "\
  git commit -m'NEW ADMIN: $GPG_KEY_EMAIL_ADDRESS' \
    .blackbox/pubring.kbx \
    .blackbox/trustdb.gpg \
    .blackbox/blackbox-admins.txt
"

exit 0
