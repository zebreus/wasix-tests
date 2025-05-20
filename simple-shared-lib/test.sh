#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
source ../lib/assert.sh

make main.wasm libside.so

wasmer run --mapdir /lib:$(pwd) main.wasm > stdout.log 2> stderr.log

assert_eq "The shared library returned: 42" "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"