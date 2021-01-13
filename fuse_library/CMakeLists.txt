cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(fuse_library VERSION 1.0.0 LANGUAGES C)
add_library(fuse_library SHARED fuse.c fuse.def)
add_executable(fuse_test fuse.c)

set_target_properties(fuse_library PROPERTIES
    PUBLIC_HEADER fuse.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    OUTPUT_NAME "fuse"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)