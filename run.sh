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
TEST_FILTER=""
LIST_TESTS=0
SHOW_HELP=0
NON_INTERACTIVE=0

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
            if [ -n "$TEST_FILTER" ]; then
                echo -e "${RED}Cannot specify multiple test filters${NC}"
                SHOW_HELP=1
                break
            fi
            TEST_FILTER="--gtest_filter=$2"
            NON_INTERACTIVE=1
            shift 2
            ;;
        --all)
            TEST_FILTER="--gtest_filter=*"
            NON_INTERACTIVE=1
            shift
            ;;
        --help)
            SHOW_HELP=1
            shift
            ;;
        *)
            if [ -n "$TEST_FILTER" ]; then
                echo -e "${RED}Cannot specify multiple test filters${NC}"
                SHOW_HELP=1
                break
            fi
            TEST_FILTER="--gtest_filter=$1"
            NON_INTERACTIVE=1
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
    echo -e "  ${WHITE}./run.sh${NC}                        Run tests interactively"
    echo -e "  ${WHITE}./run.sh --clean${NC}                Clean build and run tests interactively"
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

# Show interactive menu if no filter was provided
if [ $NON_INTERACTIVE -eq 0 ]; then
    echo -e "${YELLOW}Available tests:${NC}"

    # Define hardcoded tests for reliability, similar to run.bat
    # Add "ALL" option
    echo -e "${CYAN}0.${NC} Run ALL tests"
    echo -e "${CYAN}1.${NC} BaseTest.TriangleTypeTest"
    echo -e "${CYAN}2.${NC} BaseTest.MathUtilsTest"
    echo -e "${CYAN}3.${NC} BaseTest.TestIsPrime"

    # Ask user to select a test
    echo
    read -p $'\e[33mEnter test number to run (0 for all tests):\e[0m ' test_choice

    # Validate input and set the test filter based on selection
    case "$test_choice" in
        0) TEST_FILTER="--gtest_filter=*" ;;
        1) TEST_FILTER="--gtest_filter=BaseTest.TriangleTypeTest" ;;
        2) TEST_FILTER="--gtest_filter=BaseTest.MathUtilsTest" ;;
        3) TEST_FILTER="--gtest_filter=BaseTest.TestIsPrime" ;;
        *)
            echo -e "${RED}Invalid selection. Running all tests.${NC}"
            TEST_FILTER="--gtest_filter=*"
            ;;
    esac
fi

# Run tests with optional filter
if [ -z "$TEST_FILTER" ]; then
    TEST_FILTER="--gtest_filter=*"
fi

echo -e "${BLUE}Running tests with filter: ${WHITE}${TEST_FILTER}${NC}"
if ! ./RunTests $TEST_FILTER; then
    echo -e "${RED}Tests failed!${NC}"
    exit 1
fi

echo -e "${GREEN}${BOLD}Build and tests completed successfully!${NC}"