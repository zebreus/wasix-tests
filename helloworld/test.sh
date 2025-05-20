#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
source ../lib/assert.sh

make helloworld.wasm

wasmer run helloworld.wasm > stdout.log 2> stderr.log

assert_eq "Hello, World!" "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"