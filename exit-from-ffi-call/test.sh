#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
source ../lib/assert.sh
source ../lib/test-utils.sh

make main
set +e
run main
exitcode=$?

assert_eq "" "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"
set -e

assert_eq 4 "$exitcode" "Expected exit code 4 but got $exitcode"
