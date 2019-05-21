cmake_minimum_required(VERSION 3.9.0 FATAL_ERROR)
if (POLICY CMP0043)
  cmake_policy(SET CMP0043 NEW)
endif()

include(version.cmake)

project(%{ProjectName}
  VERSION ${VERSION}
  DESCRIPTION "Milo code DB template file"
  LANGUAGES CXX
)

# Use C++ 14 standard
set(CMAKE_CXX_STANDARD 14)
# Mark all warnings as errors
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -fPIC")

find_package(Qt5Core REQUIRED)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)
# Create code from a list of Qt designer ui files
set(CMAKE_AUTOUIC ON)
# Create code for Qt Resource Files
set(CMAKE_AUTORCC ON)

add_subdirectory(%{ProjectName})
