#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

WORKSPACE=$(mktemp -d)
BASE_DIR=$(dirname $BATS_TEST_DIRNAME)

setup() {
  cd $WORKSPACE
  rails new appname
  cd appname
  rm .ruby-version
  bin/rails db:create
  bin/rails db:migrate
  git init
  git add .
  git commit -m "Initial commit"

  run $BASE_DIR/bin/rollback enable
  assert_success

  assert [ -e $WORKSPACE/appname/.git/hooks/post-checkout ]
}

teardown() {
  if [ $BATS_TEST_COMPLETED ]; then
    echo "Deleting $WORKSPACE"
    rm -rf $WORKSPACE
  fi
}

@test 'git checkout with new migrations' {
  git checkout -b awesome-branch

  bin/rails generate migration CreateProducts name:string part_number:string

  bin/rails db:migrate

  bin/spring stop

  git add .
  git commit -m "Orphan migration"

  run git checkout master

  assert_success

  run git checkout awesome-branch

  assert_success
  assert_line --partial "Running bundle exec"
}
