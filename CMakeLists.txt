cmake_minimum_required(VERSION 3.16)
project(MyProject)

set(CMAKE_CXX_STANDARD 17)  # Use modern C++

# Define the local GoogleTest directory
set(GTEST_DIR "${CMAKE_SOURCE_DIR}/libs/googletest")

# Check if offline GoogleTest exists; if not, download it
if(NOT EXISTS ${GTEST_DIR})
    message(STATUS "GoogleTest not found. Downloading...")

    # Make sure the directory exists
    file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/libs)

    # Use execute_process to run git clone once
    execute_process(
        COMMAND git clone https://github.com/google/googletest.git ${GTEST_DIR}
        RESULT_VARIABLE GIT_RESULT
    )

    if(NOT GIT_RESULT EQUAL "0")
        message(FATAL_ERROR "Failed to clone GoogleTest repository")
    endif()
else()
    message(STATUS "Using offline GoogleTest from ${GTEST_DIR}")
endif()

# Always use the local copy
add_subdirectory(${GTEST_DIR})

# Add src and tests directories
add_subdirectory(src)
add_subdirectory(tests)
