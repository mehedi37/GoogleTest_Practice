cmake_minimum_required(VERSION 3.16)
project(MyProject)

set(CMAKE_CXX_STANDARD 17)  # Use modern C++

# Check if offline GoogleTest exists; if not, download the latest version
set(GTEST_DIR "${CMAKE_SOURCE_DIR}/libs/googletest")
if(EXISTS ${GTEST_DIR})
    message(STATUS "Using offline GoogleTest from ${GTEST_DIR}")
    add_subdirectory(${GTEST_DIR})
else()
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG main  # Always fetch the latest version
        DOWNLOAD_EXTRACT_TIMESTAMP true  # Fix timestamp warning
    )
    FetchContent_MakeAvailable(googletest)
endif()

# Add src and tests directories
add_subdirectory(src)
add_subdirectory(tests)
