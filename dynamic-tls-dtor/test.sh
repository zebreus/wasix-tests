#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
source ../lib/assert.sh
source ../lib/test-utils.sh

make libtlsdtor.so main
run main

assert_eq "tls dtor fired" "$(cat stdout.log)" "destructor did not run"
assert_eq "" "$(cat stderr.log)" "stderr not empty"

