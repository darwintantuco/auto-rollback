#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

AWESOME_REPO=$(mktemp -d)
BASE_DIR=$(dirname $BATS_TEST_DIRNAME)

@test 'git checkout' {
}
