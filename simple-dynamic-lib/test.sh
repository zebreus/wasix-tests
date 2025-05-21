#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
source ../lib/assert.sh
source ../lib/test-utils.sh

build_targets libside.so main.wasm
run_wasm main.wasm

assert_eq "The dynamic library returned: 42" "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"

