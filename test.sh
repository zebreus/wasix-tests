#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

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

