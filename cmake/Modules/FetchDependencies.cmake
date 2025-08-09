include(FetchContent)

# Set fetch content properties
set(FETCHCONTENT_QUIET FALSE)
set(FETCHCONTENT_UPDATES_DISCONNECTED TRUE)

# nlohmann/json for JSON parsing
FetchContent_Declare(
    nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG v3.11.3
    GIT_SHALLOW TRUE
)

# SQLiteCpp for database access
FetchContent_Declare(
    SQLiteCpp
    GIT_REPOSITORY https://github.com/SRombauts/SQLiteCpp.git
    GIT_TAG 3.3.1
    GIT_SHALLOW TRUE
)

# Configure SQLiteCpp options
set(SQLITECPP_RUN_CPPLINT OFF CACHE BOOL "" FORCE)
set(SQLITECPP_RUN_CPPCHECK OFF CACHE BOOL "" FORCE)
set(SQLITECPP_USE_STATIC_RUNTIME ${STATIC_BUILD} CACHE BOOL "" FORCE)
set(SQLITECPP_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(SQLITECPP_BUILD_TESTS OFF CACHE BOOL "" FORCE)

# libcurl for network operations
if(WIN32)
    # On Windows, we'll use the pre-built curl
    set(CURL_USE_WINSSL ON CACHE BOOL "Use Windows SSL")
    set(BUILD_CURL_EXE OFF CACHE BOOL "Don't build curl executable")
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build static libs")
    set(HTTP_ONLY ON CACHE BOOL "Only HTTP support")
    set(CURL_DISABLE_LDAP ON CACHE BOOL "Disable LDAP")
    
    FetchContent_Declare(
        curl
        GIT_REPOSITORY https://github.com/curl/curl.git
        GIT_TAG curl-8_5_0
        GIT_SHALLOW TRUE
    )
    FetchContent_MakeAvailable(nlohmann_json SQLiteCpp curl)
else()
    # On Linux, try to find system curl first
    find_package(CURL)
    if(NOT CURL_FOUND)
        message(STATUS "System CURL not found, fetching...")
        FetchContent_Declare(
            curl
            GIT_REPOSITORY https://github.com/curl/curl.git
            GIT_TAG curl-8_5_0
            GIT_SHALLOW TRUE
        )
        set(BUILD_CURL_EXE OFF CACHE BOOL "Don't build curl executable")
        set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build static libs")
        set(HTTP_ONLY ON CACHE BOOL "Only HTTP support")
        set(CURL_DISABLE_LDAP ON CACHE BOOL "Disable LDAP")
        FetchContent_MakeAvailable(nlohmann_json SQLiteCpp curl)
    else()
        FetchContent_MakeAvailable(nlohmann_json SQLiteCpp)
    endif()
endif()

message(STATUS "Dependencies configured successfully")