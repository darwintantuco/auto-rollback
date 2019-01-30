#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

AWESOME_REPO=$(mktemp -d)
BASE_DIR=$(dirname $BATS_TEST_DIRNAME)

setup() {
  cd $AWESOME_REPO
}

teardown() {
  echo "Deleting $AWESOME_REPO"
  rm -rf $AWESOME_REPO
}

dummy_rails_app() {
  echo rails > Gemfile

  assert [ -e $AWESOME_REPO/Gemfile ]
}

initialize_git() {
  git init
  echo "AWESOME TEXT" > awesome.txt
  git add awesome.txt
  git commit -m "Initial commit"
}

@test 'rollback --enable on rails app' {
  initialize_git
  dummy_rails_app

  run $BASE_DIR/bin/rollback --enable

  assert_success
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout ]
}

@test 'rollback --disable on rails app' {
  initialize_git
  dummy_rails_app

  run $BASE_DIR/bin/rollback --enable

  assert_success
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout ]
}

@test 'rollback --enable on unsupported app' {
  initialize_git

  run $BASE_DIR/bin/rollback --enable

  assert_failure
}

@test 'rollback invalid args on rails app' {
  initialize_git
  dummy_rails_app

  run $BASE_DIR/bin/rollback kappa

  assert_failure
  assert_line --partial "rollback kappa is invalid"
}

@test 'rollback invalid args on unsupported app' {
  initialize_git

  run $BASE_DIR/bin/rollback kappa

  assert_failure
  assert_line --partial "rollback kappa is invalid"
}

@test 'rollback on non git repo' {
  run $BASE_DIR/bin/rollback kappa

  assert_failure
  assert_line --partial "rollback should be executed on a git repository"
}

@test 'rollback --enable backup existing post-checkout hook' {
  initialize_git
  dummy_rails_app
  echo dummy > $AWESOME_REPO/.git/hooks/post-checkout

  run $BASE_DIR/bin/rollback --enable

  assert_success
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout ]
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout.old ]
}
