#!/bin/bash

set -ex

# print the environment and exit without error if ctrl+c pressed
finish () {
  env
  echo 'Exiting...'
  exit 0
}

trap finish SIGINT

. "$HOME/.bashrc"

export GNUPGHOME=${GNUPGHOME:-'/root/.gnupg'}
export BLACKBOXDATA=${BLACKBOXDATA:-'.blackbox'}

should_set_git_config="true"

if [ -z "$GIT_USER_EMAIL" ] || [ -z "$GIT_USER_NAME" ]
then
  echo "\
    You need to set the 'GIT_USER_EMAIL' and 'GIT_USER_NAME' environment \
    variables for this script to function properly"

  should_set_git_config="false"
fi

set_git_config () {
  user_email="$1"
  user_name="$2"

  git config --global user.email "$user_email"
  git config --global user.name "$user_name"
}

main () {
  start_gpg_agent

  if [ "$should_set_git_config" == "true" ]
  then
    set_git_config "$GIT_USER_EMAIL" "$GIT_USER_NAME"
  fi

  # ensures directory is created for blackbox key storage
  mkdir -p "$BLACKBOXDATA"
}

main

$@

set +ex

exit 0
