#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# Ensure tput based color output works even in non-interactive environments
export TERM="${TERM:-xterm-256color}"
export WASIX_SYSROOT="${WASIX_SYSROOT:-/wasix-sysroot}"

disabled_tests=("minimal-threadlocal" "extern-threadlocal-nopic")

for tool in wasix emscripten; do
    echo "### Running $tool tests"
    export PATH="$(pwd)/scripts:$PATH"
    export CC="${tool}-clang" CXX="${tool}-clang++" LD="${tool}-clang"

    for testfile in ./*/test.sh; do
        testdir=$(dirname "$testfile")
        testname=$(basename "$testdir")

        if [[ " ${disabled_tests[@]} " =~ " ${testname} " ]]; then
            echo "Skipping disabled test: $testname ($tool)"
            continue
        fi

        echo "Running test: $testname ($tool)"

        if bash "$testfile"; then
            echo "Test $testname passed."
        else
            echo "Test $testname failed."
        fi
        echo "--------------------------------"
    done
done

