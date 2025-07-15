#!/usr/bin/env bash
set -euo pipefail

# Run the specified file using $RUNNER (or use a native runner if not set)
run() {
    # set -x
    # trap 'set +x' RETURN

    RUNNER=${RUNNER:-../lib/wrappers/native-clang-runner}
    local executable="$1"
    shift

    exitcode=0
    "$RUNNER" "./$executable" "$@" > stdout.log 2> stderr.log || exitcode=$?

    if [ "$exitcode" -ne "0" ]; then
        assert_eq 0 "$exitcode" "run failed: $(cat stderr.log)" || true
    fi
    return $exitcode
}

