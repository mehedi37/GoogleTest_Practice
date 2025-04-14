enable_testing()

add_executable(RunTests
    test_math_utils.cpp
    test_triangle.cpp
    test_isprime.cpp
    test_maxnumber.cpp
)

target_include_directories(RunTests
    PRIVATE
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(RunTests
    MyLibrary
    gtest
    gtest_main
)

add_test(NAME RunTests COMMAND RunTests)

# Optional: Print which test files were found
message(STATUS "Test sources: ${TEST_SOURCES}")