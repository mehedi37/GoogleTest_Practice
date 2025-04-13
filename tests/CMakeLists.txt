enable_testing()

# Automatically find all test files
file(GLOB TEST_SOURCES "*.cpp")

add_executable(RunTests ${TEST_SOURCES})

target_include_directories(RunTests
    PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${GTEST_DIR}/googletest/include
)

target_link_libraries(RunTests
    PRIVATE
    MyLibrary
    gtest
    gtest_main
)

add_test(NAME RunTests COMMAND RunTests)

# Optional: Print which test files were found
message(STATUS "Test sources: ${TEST_SOURCES}")