#!/usr/bin/env bash
set -euo pipefail

# Run the specified file using $RUNNER (or use a native runner if not set)
run() {
    RUNNER=${RUNNER:-../lib/wrappers/native-clang-runner}
    local executable="$1"
    shift

    $RUNNER "./$executable" "$@" > stdout.log 2> stderr.log
    local status=$?

    if [ "$status" -ne 0 ]; then
        assert_eq 0 "$status" "run failed: $(cat stderr.log)"
        return "$status"
    fi
}

