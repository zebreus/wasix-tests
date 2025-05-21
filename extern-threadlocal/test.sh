#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
source ../lib/assert.sh
source ../lib/test-utils.sh

build_targets main.wasm
run_wasm main.wasm

assert_eq "error number: 999" "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"

