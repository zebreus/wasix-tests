#!/usr/bin/env bash

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