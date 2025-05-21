#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# Ensure tput based color output works even in non-interactive environments
export TERM="${TERM:-xterm-256color}"

for tool in wasix emscripten; do
    echo "### Running $tool tests"
    export PATH="$(pwd)/scripts:$PATH"
    export CC="${tool}-clang" CXX="${tool}-clang++" LD="${tool}-clang"

    for testfile in ./*/test.sh; do
        testdir=$(dirname "$testfile")
        testname=$(basename "$testdir")
        echo "Running test: $testname ($tool)"

        if bash "$testfile"; then
            echo "Test $testname passed."
        else
            echo "Test $testname failed."
        fi
        echo "--------------------------------"
    done
done

