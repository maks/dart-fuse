cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(fuse_library VERSION 1.0.0 LANGUAGES C)

# c compiler flag needed for fuse 
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_FILE_OFFSET_BITS=64")

# path to cmake file that has magic to find fuse lib location on system 
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH})
find_package(FUSE REQUIRED)
include_directories(${FUSE_INCLUDE_DIR})

add_library(dartfuse_library SHARED dartfuse.c dartfuse.def)
target_link_libraries(dartfuse_library ${FUSE_LIBRARIES})

# exe just for initial testing, remove later
add_executable(fuse_test dartfuse.c)
target_link_libraries(fuse_test ${FUSE_LIBRARIES})

set_target_properties(dartfuse_library PROPERTIES
    PUBLIC_HEADER fuse.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    OUTPUT_NAME "dartfuse"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)