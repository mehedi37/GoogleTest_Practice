file(GLOB LIB_SOURCES "*.cpp")

add_library(MyLibrary ${LIB_SOURCES})

target_include_directories(MyLibrary
    PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)
message(STATUS "Library sources: ${LIB_SOURCES}")