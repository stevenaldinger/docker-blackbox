#!/bin/bash

set -ex

. "$HOME/.bashrc"

user_email="$GIT_USER_EMAIL"
user_name="$GIT_USER_NAME"

set_git_config () {
  user_email="$1"
  user_name="$2"

  git config --global user.email "$user_email"
  git config --global user.name "$user_name"
}

main () {
  start_gpg_agent
  set_git_config "$user_email" "$user_name"
  # ensures directory is created for blackbox key storage
  mkdir -p "$BLACKBOXDATA"
}

main

$@

set +ex

exit 0
