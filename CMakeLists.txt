cmake_minimum_required(VERSION 3.20)
project(ComfySkyEngine VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set default build type if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Options
option(BUILD_TESTS "Build test suite" OFF)
option(STATIC_BUILD "Build statically linked executable" ON)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Platform-specific settings
if(WIN32)
    add_definitions(-DCSE_WINDOWS)  # Changed to avoid conflict with curl
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    add_definitions(-DNOMINMAX)  # Avoid Windows.h min/max macros
    
    # Set subsystem to console for Windows
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /SUBSYSTEM:CONSOLE")
    
    # Enable static runtime on MSVC
    if(MSVC AND STATIC_BUILD)
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
elseif(UNIX AND NOT APPLE)
    add_definitions(-DCSE_LINUX)  # Changed to avoid conflict
    
    # Linux-specific flags
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")
    
    if(STATIC_BUILD)
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -static-libstdc++")
    endif()
endif()

# Include custom cmake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# Fetch and configure dependencies
include(FetchDependencies)

# Find required system libraries
find_package(Threads REQUIRED)

# Platform-specific libraries
set(PLATFORM_LIBS)
if(WIN32)
    list(APPEND PLATFORM_LIBS ws2_32 wininet urlmon)
elseif(UNIX)
    list(APPEND PLATFORM_LIBS pthread dl)
endif()

# Collect source files
file(GLOB_RECURSE SOURCES 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
)

file(GLOB_RECURSE HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
)

# Create executable
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

# Include directories
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/external
)

# Link libraries
target_link_libraries(${PROJECT_NAME} PRIVATE
    nlohmann_json::nlohmann_json
    SQLiteCpp
    sqlite3
    CURL::libcurl
    Threads::Threads
    ${PLATFORM_LIBS}
)

# Copy database files to build directory (if they exist)
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/data/schema.sql)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/data/schema.sql
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/data/schema.sql
        COPYONLY
    )
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/data/seed_data.sql)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/data/seed_data.sql
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/data/seed_data.sql
        COPYONLY
    )
endif()

# Create data directory in build folder
file(MAKE_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/data)

# Installation rules
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

# Install database files if they exist
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/data)
    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/data
        DESTINATION bin
        FILES_MATCHING PATTERN "*.sql"
    )
endif()

# Tests
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# Print build configuration
message(STATUS "")
message(STATUS "Build Configuration:")
message(STATUS "  Platform: ${CMAKE_SYSTEM_NAME}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Static Build: ${STATIC_BUILD}")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "  Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")