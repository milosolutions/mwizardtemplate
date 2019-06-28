
include(../version.cmake)

project(tests
  VERSION ${VERSION}
  DESCRIPTION "Unit tests"
  LANGUAGES CXX
)

include(../qtbase.cmake)

find_package(Qt5 COMPONENTS REQUIRED Core)

enable_testing(true)

add_subdirectory(tst_project)
