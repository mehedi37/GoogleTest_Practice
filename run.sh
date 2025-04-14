#!/bin/bash

# Color definitions using tput for better terminal compatibility
if [ -t 1 ] && command -v tput >/dev/null && [ "$(tput colors)" -ge 8 ]; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
    BOLD=$(tput bold)
    NC=$(tput sgr0) # Reset
else
    # No color support
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    MAGENTA=''
    CYAN=''
    WHITE=''
    BOLD=''
    NC=''
fi

# Base directory - use absolute path
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
build_dir="${base_dir}/.build"

# Parse command line arguments
CLEAN_BUILD=0
TEST_FILTER="--gtest_filter=*"
LIST_TESTS=0
SHOW_HELP=0

# Process arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --clean)
            CLEAN_BUILD=1
            shift
            ;;
        --list)
            LIST_TESTS=1
            shift
            ;;
        --filter)
            TEST_FILTER="--gtest_filter=$2"
            shift 2
            ;;
        --all)
            TEST_FILTER="--gtest_filter=*"
            shift
            ;;
        --help)
            SHOW_HELP=1
            shift
            ;;
        *)
            TEST_FILTER="--gtest_filter=$1"
            shift
            ;;
    esac
done

# Show help if requested
if [ $SHOW_HELP -eq 1 ]; then
    echo -e "${CYAN}${BOLD}GoogleTest Runner for Linux - Usage:${NC}"
    echo
    echo -e "  ${WHITE}$(basename "$0") [options] [test_filter]${NC}"
    echo
    echo -e "${CYAN}${BOLD}Options:${NC}"
    echo -e "  ${WHITE}--clean${NC}        Perform a clean build (delete .build folder)"
    echo -e "  ${WHITE}--list${NC}         List all available tests"
    echo -e "  ${WHITE}--filter VALUE${NC} Run tests matching the filter pattern"
    echo -e "  ${WHITE}--all${NC}          Run all tests (default)"
    echo -e "  ${WHITE}--help${NC}         Show this help message"
    echo
    echo -e "${CYAN}${BOLD}Examples:${NC}"
    echo -e "  ${WHITE}./run.sh${NC}                        Run all tests"
    echo -e "  ${WHITE}./run.sh --clean${NC}                Clean build and run all tests"
    echo -e "  ${WHITE}./run.sh --list${NC}                 List all tests"
    echo -e "  ${WHITE}./run.sh TriangleTypeTest.*${NC}     Run all tests in TriangleTypeTest"
    echo -e "  ${WHITE}./run.sh \"*.HandlesZeroInput\"${NC}   Run all tests named HandlesZeroInput"
    echo -e "  ${WHITE}./run.sh --filter \"*Type*\"${NC}      Run tests with 'Type' in their name"
    echo
    exit 0
fi

# Check if we have execution permissions
if [[ ! -x "$0" ]]; then
    echo -e "${RED}Error: Script needs execution permissions${NC}"
    echo -e "Please run: ${WHITE}chmod +x $0${NC}"
    exit 1
fi

echo -e "${CYAN}${BOLD}GoogleTest Runner for Linux/Mac${NC}"
echo

# Clean only if requested
if [ $CLEAN_BUILD -eq 1 ]; then
    echo -e "${YELLOW}Cleaning build directory...${NC}"
    rm -rf "${build_dir}"
fi

# Create build directory if it doesn't exist
if [ ! -d "${build_dir}" ]; then
    echo -e "${YELLOW}Creating build directory...${NC}"
    mkdir -p "${build_dir}"
fi

echo -e "${BLUE}Entering build directory...${NC}"
cd "${build_dir}" || {
    echo -e "${RED}Failed to enter build directory${NC}"
    exit 1
}

echo -e "${BLUE}Running CMake...${NC}"
if ! cmake ..; then
    echo -e "${RED}CMake configuration failed${NC}"
    exit 1
fi

echo -e "${BLUE}Building project...${NC}"
# Detect number of CPU cores for parallel build
NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
if ! make -j"$NPROC"; then
    echo -e "${RED}Build failed${NC}"
    exit 1
fi

# Go to tests directory
if ! cd "${build_dir}/tests/"; then
    echo -e "${RED}Could not find tests directory${NC}"
    exit 1
fi

# Handle test listing
if [ $LIST_TESTS -eq 1 ]; then
    echo -e "${YELLOW}Available tests:${NC}"
    ./RunTests --gtest_list_tests
    exit 0
fi

# Run tests with filter
echo -e "${BLUE}Running tests with filter: ${WHITE}${TEST_FILTER}${NC}"
if ! ./RunTests $TEST_FILTER; then
    echo -e "${RED}Tests failed!${NC}"
    exit 1
fi

echo -e "${GREEN}${BOLD}Build and tests completed successfully!${NC}"