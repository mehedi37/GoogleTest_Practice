#!/bin/bash

# Exit on any error
set -e

# Base directory - use absolute path
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
build_dir="${base_dir}/.build"

# Check if we have execution permissions
if [[ ! -x "$0" ]]; then
    echo "Error: Script needs execution permissions"
    echo "Please run: chmod +x $0"
    exit 1
fi

echo "Cleaning build directory..."
rm -rf "${build_dir}"

echo "Creating build directory..."
mkdir -p "${build_dir}"

echo "Entering build directory..."
cd "${build_dir}"

echo "Running CMake..."
cmake .. || { echo "CMake configuration failed"; exit 1; }

echo "Building project..."
make || { echo "Build failed"; exit 1; }

echo "Running tests..."
cd "${build_dir}/tests/" || { echo "Could not find tests directory"; exit 1; }
./RunTests

echo "Build and test completed successfully"
