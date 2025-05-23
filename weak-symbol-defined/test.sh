#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
source ../lib/assert.sh
source ../lib/test-utils.sh

make main
run main

assert_eq "other_func returned 42" "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"

