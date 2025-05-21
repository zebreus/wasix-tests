#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

for makefile in ./*/Makefile; do
    makedir=$(dirname "$makefile")
    echo "Cleaning up directory: $makedir"
    make -C "$makedir" clean || true
    echo "--------------------------------"
done

