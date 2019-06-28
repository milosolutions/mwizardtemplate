
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

# TODO: parametrize (auto-insert based on modules chosen in wizard)
add_subdirectory(../milo/mlog/tst_mlog milo/mlog/tst_mlog_bin)
