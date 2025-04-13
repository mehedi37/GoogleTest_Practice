#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if terminal supports colors
if [ -t 1 ] && command -v tput >/dev/null && [ "$(tput colors)" -ge 8 ]; then
    HAS_COLORS=1
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
    echo -e "${CYAN}${BOLD}GoogleTest Runner for Linux/Mac - Usage:${NC}"
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

    # Get test list and store it
    ./RunTests --gtest_list_tests > test_list.tmp

    # Create arrays to store test names and display names
    declare -a test_names
    declare -a display_names

    # Add "ALL" option
    test_names[0]="*"
    display_names[0]="Run ALL tests"
    echo -e "${CYAN}0.${NC} Run ALL tests"

    # Process test list
    current_suite=""
    counter=1
    skip_next=0

    while IFS= read -r line; do
        # Skip Google Test main line
        if [[ "$line" == "Running main() from"* ]]; then
            skip_next=1
            continue
        fi

        # Skip the path line after "Running main() from"
        if [ $skip_next -eq 1 ]; then
            skip_next=0
            continue
        fi

        # If line ends with a period, it's a test suite
        if [[ "$line" == *. ]]; then
            # Only consider BaseTest suite
            if [[ "$line" == "BaseTest." ]]; then
                current_suite="$line"
            else
                current_suite=""
            fi
        # It's a test within our target suite
        elif [[ -n "$current_suite" ]]; then
            # Trim leading whitespace
            trimmed_line="${line#"${line%%[![:space:]]*}"}"
            test_name="${current_suite}${trimmed_line}"
            test_names[$counter]="$test_name"
            display_names[$counter]="$test_name"
            echo -e "${CYAN}${counter}.${NC} ${test_name}"
            ((counter++))
        fi
    done < test_list.tmp

    rm test_list.tmp

    # Ask user to select a test
    echo
    read -p $'\e[33mEnter test number to run (0 for all tests):\e[0m ' test_choice

    # Validate input
    if ! [[ "$test_choice" =~ ^[0-9]+$ ]] || [ "$test_choice" -ge ${#test_names[@]} ]; then
        echo -e "${RED}Invalid selection. Running all tests.${NC}"
        test_choice=0
    fi

    # Set the test filter based on selection
    TEST_FILTER="--gtest_filter=${test_names[$test_choice]}"
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