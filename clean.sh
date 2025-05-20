#!/usr/bin/env bash

for makefile in ./*/Makefile; do
    makedir=$(dirname "$makefile")
    echo "Cleaning up directory: $makedir"
    make -C "$makedir" clean || true
    echo "--------------------------------"
done