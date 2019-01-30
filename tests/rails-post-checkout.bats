#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

WORKSPACE=$(mktemp -d)
BASE_DIR=$(dirname $BATS_TEST_DIRNAME)

setup() {
  cd $WORKSPACE
  run rails new appname
  run rails db:create
  run rails db:migrate
}

teardown() {
  if [ $BATS_TEST_COMPLETED ]; then
    echo "Deleting $WORKSPACE"
    rm -rf $WORKSPACE
  fi
}

@test 'git checkout with new migrations' {
  # normal checkout
}
