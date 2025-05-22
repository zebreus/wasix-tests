#!/usr/bin/env bash
set -euo pipefail

# Run the specified file using $RUNNER (or use a native runner if not set)
run() {
    RUNNER=${RUNNER:-../scripts/native-clang-runner}
    local executable="$1"
    shift
    if ! $RUNNER "./$executable" "$@" > stdout.log 2> stderr.log; then
        assert_eq 0 "$?" "run failed: $(cat stderr.log)"
    fi
}

