#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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

echo -e "${GREEN}\t========================================================${NC}"
echo -e "${GREEN}\t\tBuilding and Testing GoogleTest Project\t\t${NC}"
echo -e "${GREEN}\t========================================================${NC}"

echo "Cleaning build directory..."
rm -rf "${build_dir}"

echo "Creating build directory..."
mkdir -p "${build_dir}"

echo "Entering build directory..."
cd "${build_dir}"

echo "Running CMake..."
if ! cmake ..; then
    echo -e "${RED}CMake configuration failed${NC}"
    exit 1
fi

echo "Building project..."
if ! make; then
    echo -e "${RED}Build failed${NC}"
    exit 1
fi

echo "Running tests..."
if ! cd "${build_dir}/tests/"; then
    echo -e "${RED}Could not find tests directory${NC}"
    exit 1
fi
./RunTests

echo -e "${GREEN}\t========================================================${NC}"
echo -e "${GREEN}\t\t\tBuild and Test Complete\t\t\t${NC}"
echo -e "${GREEN}\t========================================================${NC}"