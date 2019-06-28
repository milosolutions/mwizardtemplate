
include(../../qtbase.cmake)

find_package(Qt5 COMPONENTS REQUIRED Core Test)

#add_library(tests OBJECT ${SOURCES} ${OTHER_FILES})
add_executable(tst_project tst_testcmake.cpp)

#target_include_directories(tests
#  PUBLIC
#  $<INSTALL_INTERFACE:include>
#  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#)

## Mark all warnings as errors
target_compile_options(tst_project PRIVATE -Werror -fPIC)

## Enable LTCG (link time optimization)
#option (ltcg "Enable LTCG (link time optimization)" OFF)
#if (ltcg)
#  set_property(TARGET tests PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
#endif (ltcg)

## Use C++ 14 standard
target_compile_features(tst_project PRIVATE cxx_std_14)

## Defines
target_compile_definitions(tst_project PRIVATE QT_USE_QSTRINGBUILDER)

target_link_libraries(tst_project
  Qt5::Core Qt5::Test
)

add_test(tst_project tst_project)
