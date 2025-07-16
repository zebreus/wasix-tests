#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

source ../lib/assert.sh
source ../lib/test-utils.sh

make libside.so main
run main

assert_eq $'called' "$(cat stdout.log)" "stdout did not match expected value"
assert_eq "" "$(cat stderr.log)" "stderr did not match expected value"
