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

@test 'auto-rollback enable on rails app' {
  initialize_git
  dummy_rails_app

  run $BASE_DIR/bin/auto-rollback enable

  assert_success
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout ]
}

@test 'auto-rollback disable on rails app' {
  initialize_git
  dummy_rails_app

  run $BASE_DIR/bin/auto-rollback enable

  assert_success
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout ]
}

@test 'auto-rollback enable on unsupported app' {
  initialize_git

  run $BASE_DIR/bin/auto-rollback enable

  assert_failure
}

@test 'auto-rollback invalid args on rails app' {
  initialize_git
  dummy_rails_app

  run $BASE_DIR/bin/auto-rollback kappa

  assert_failure
  assert_line --partial "auto-rollback kappa is invalid"
}

@test 'auto-rollback invalid args on unsupported app' {
  initialize_git

  run $BASE_DIR/bin/auto-rollback kappa

  assert_failure
  assert_line --partial "auto-rollback kappa is invalid"
}

@test 'auto-rollback on non git repo' {
  run $BASE_DIR/bin/auto-rollback kappa

  assert_failure
  assert_line --partial "auto-rollback should be executed on a git repository"
}

@test 'auto-rollback enable backup existing post-checkout hook' {
  initialize_git
  dummy_rails_app
  echo dummy > $AWESOME_REPO/.git/hooks/post-checkout

  run $BASE_DIR/bin/auto-rollback enable

  assert_success
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout ]
  assert [ -e $AWESOME_REPO/.git/hooks/post-checkout.old ]
}

@test 'auto-rollback status on auto-rollback enabled app' {
  initialize_git
  dummy_rails_app

  $BASE_DIR/bin/auto-rollback enable
  run $BASE_DIR/bin/auto-rollback status

  assert_success
  assert_line --partial "enabled"
}


@test 'auto-rollback status on clean app' {
  initialize_git
  dummy_rails_app

  run $BASE_DIR/bin/auto-rollback status

  assert_success
  assert_line --partial "disabled"
}
