cmake_minimum_required(VERSION 3.30)

project(Raylib C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(RAYLIB_PATH ${CMAKE_CURRENT_SOURCE_DIR}/external/raylib)
set(RAYLIB_BUILD_PATH ${RAYLIB_PATH}/build/raylib)

if (NOT EXISTS ${RAYLIB_BUILD_PATH})
    message(FATAL_ERROR "Raylib has not ben compiled, run the setup script")
endif()

if (NOT EXISTS ${RAYLIB_BUILD_PATH}/include/rcamera.h)
    configure_file(${RAYLIB_PATH}/src/rcamera.h ${RAYLIB_BUILD_PATH}/include COPYONLY)
endif()

set(RAYLIB_LIB ${RAYLIB_BUILD_PATH}/libraylib.a)
set(RAYLIB_HEADERS ${RAYLIB_BUILD_PATH}/include)

set(SRC "src/main.c")

add_executable(application ${SRC})

set_target_properties(application PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/debug"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/release"
)

add_custom_target(
    run
    DEPENDS application
    COMMAND $<TARGET_FILE:application>
    WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)

target_compile_options(application PRIVATE -Wall -Wextra -pedantic)

target_include_directories(application PRIVATE ${RAYLIB_HEADERS})

target_link_libraries(application ${RAYLIB_LIB})

if(APPLE)
    target_link_libraries(application "-framework Cocoa -framework IOKit")
endif()
