#!/usr/bin/env bash
set -euo pipefail

# Build all targets passed as arguments
build_targets() {
    make "$@"
}

# Run the specified wasm file using wasmer
run_wasm() {
    local wasm_file="$1"
    if ! ${WASMER:-wasmer} run --mapdir /lib:$(pwd) "$wasm_file" \
        > stdout.log 2> stderr.log; then
        assert_eq 0 "$?" "wasmer run failed: $(cat stderr.log)"
    fi
}

