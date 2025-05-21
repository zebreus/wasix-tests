#!/usr/bin/env bash

# Ensure tput based color output works even in non-interactive environments
export TERM="${TERM:-xterm-256color}"

for testfile in ./*/test.sh; do
    testdir=$(dirname "$testfile")
    testname=$(basename "$testdir")
    echo "Running test: $testname"

    if bash "$testfile"; then
        echo "Test $testname passed."
    else
        echo "Test $testname failed."
    fi
    echo "--------------------------------"
done