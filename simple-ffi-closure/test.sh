#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
source ../lib/assert.sh
source ../lib/test-utils.sh

make main
run main

assert_contain "$(cat stdout.log)" "Closure test completed" "Closure test did not complete successfully"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"
