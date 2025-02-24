add_library(MyLibrary
    # math_utils.cpp
    # triangle.cpp
    isprime.cpp
)

target_include_directories(MyLibrary
    PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)