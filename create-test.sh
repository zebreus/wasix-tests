#!/usr/bin/env bash
set -e

# This script is used to create a test directory for the given test name.
# Copies from helloworld and takes a new name as first parameter.

# Check if test name is provided
if [ $# -eq 0 ]; then
    echo "Error: No test name provided."
    echo "Usage: $0 <test-name>"
    exit 1
fi

TEST_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/helloworld"
DEST_DIR="$SCRIPT_DIR/$TEST_NAME"

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: Template directory '$TEMPLATE_DIR' not found."
    exit 1
fi

# Check if destination directory already exists
if [ -d "$DEST_DIR" ]; then
    echo "Error: Test directory '$DEST_DIR' already exists."
    exit 1
fi

# Create new test directory
echo "Creating test directory: $TEST_NAME"
cp -r "$TEMPLATE_DIR" "$DEST_DIR"

# Replace occurrences of \"helloworld\" with the new test name in key files
find "$DEST_DIR" -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "Makefile" -o -name "*.toml" \) -exec sed -i "s/helloworld/$TEST_NAME/g" {} \;

# Rename the main source file if it follows the template naming
if [ -f "$DEST_DIR/helloworld.c" ]; then
    mv "$DEST_DIR/helloworld.c" "$DEST_DIR/$TEST_NAME.c"
elif [ -f "$DEST_DIR/helloworld.cpp" ]; then
    mv "$DEST_DIR/helloworld.cpp" "$DEST_DIR/$TEST_NAME.cpp"
fi

echo "Test directory '$TEST_NAME' created successfully."

