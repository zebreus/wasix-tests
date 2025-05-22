#!/usr/bin/env bash
# This test should pass with both wasix-clang and native gcc/clang
set -euo pipefail
cd "$(dirname "$0")"
source ../lib/assert.sh
source ../lib/test-utils.sh

make main
run main

expected=$'main errno 1\nthread 0 errno 100\nthread 1 errno 101\nthread 2 errno 102\nthread 3 errno 103'
assert_eq "$expected" "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"
