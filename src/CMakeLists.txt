add_library(MyLibrary
    math_utils.cpp
    # string_utils.cpp
)

target_include_directories(MyLibrary
    PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)