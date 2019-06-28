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

# This has to be below project() because it calls find_* function
include(qtbase.cmake)

# MCDB modules
add_subdirectory(milo/mlog)
add_subdirectory(milo/mconfig)

# Unit tests
add_subdirectory(tests)

set(SOURCES
  src/main.cpp
)

set(RESOURCES
  qml/qml.qrc
  resources/resources.qrc
)

set(OTHER_FILES
  README.md
  Release.md
  AUTHORS.md
  LICENSE-MiloCodeDB.txt
  license-Qt.txt
  %{ProjectName}.doxyfile.in
  .clang-format
  .gitignore
  .gitlab-ci.yml
)

add_executable(%{ProjectName} ${SOURCES} ${OTHER_FILES}
  $<TARGET_OBJECTS:mlog>
  $<TARGET_OBJECTS:mconfig>
)

target_include_directories(%{ProjectName} PUBLIC
  $<TARGET_PROPERTY:mlog,INCLUDE_DIRECTORIES>
  $<TARGET_PROPERTY:mconfig,INCLUDE_DIRECTORIES>
)

# Mark all warnings as errors
target_compile_options(%{ProjectName} PRIVATE -Werror -fPIC)

# Defines
target_compile_definitions(%{ProjectName} PRIVATE QT_USE_QSTRINGBUILDER)

# Enable LTCG (link time optimization)
option (ltcg "Enable LTCG (link time optimization)" OFF)
if (ltcg)
  set_property(TARGET %{ProjectName} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
  message("Building with LTCG enabled")
endif (ltcg)

# Use C++ 14 standard
target_compile_features(%{ProjectName} PRIVATE cxx_std_14)

target_link_libraries(%{ProjectName}
  Qt5::Core
)
