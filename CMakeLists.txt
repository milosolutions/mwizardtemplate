cmake_minimum_required(VERSION 3.9.0 FATAL_ERROR)
if (POLICY CMP0043)
  cmake_policy(SET CMP0043 NEW)
endif ()

# Fix project() setting VERSION parameter
if (POLICY CMP0048)
  cmake_policy(SET CMP0048 NEW)
endif ()

project(%{ProjectName}
  VERSION 0.0.1
  DESCRIPTION "Milo code DB template file"
  LANGUAGES CXX
)

# On first run, if GIT repository is missing, the script below will initialize
# a new GIT repository and add all MCDB submodules. Once it's ready, you can
# safely remove this line!
include(first-time-setup.cmake)

# Central place for versioning information for all platforms, installers
# and documentation
include(version.cmake)

# QtCreator supports the following variables for Android, which are identical
# to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.
if(ANDROID)
#  set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/platforms/android/android")
#  if (ANDROID_ABI STREQUAL "armeabi-v7a")
#    set(ANDROID_EXTRA_LIBS
#      ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#      ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#  endif()
endif()

# This has to be below project() because it calls find_* function
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Quick REQUIRED)

## Use concrete C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)
# Create code from a list of Qt designer ui files
set(CMAKE_AUTOUIC ON)
# Create code for Qt Resource Files
set(CMAKE_AUTORCC ON)

## Defines
add_compile_definitions(QT_USE_QSTRINGBUILDER)

# Enable LTCG (link time optimization)
option (ltcg "Enable LTCG (link time optimization)" OFF)
if (ltcg)
  set_property(TARGET project-lib PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
  set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
  message("Building with LTCG enabled")
endif (ltcg)

# Unit tests
#if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND BUILD_TESTING)
include(CTest)
add_subdirectory(tests)
enable_testing()
#endif ()

# MCDB modules
# MScripts is indentionally left out - there is no C++ code there

@if "%{mbarcodescannerCheckBox}" == "mbarcodescannerChBChecked"
add_subdirectory(milo/mbarcodescanner)
@endif
@if "%{mchartsCheckBox}" == "mchartsChBChecked"
add_subdirectory(milo/mcharts)
@endif
@if "%{mconfigCheckBox}" == "mconfigChBChecked"
add_subdirectory(milo/mconfig)
@endif
@if "%{mcryptoCheckBox}" == "mcryptoChBChecked"
add_subdirectory(milo/mcrypto)
@endif
@if "%{mlogCheckBox}" == "mlogChBChecked"
add_subdirectory(milo/mlog)
@endif
@if "%{mrestapiCheckBox}" == "mrestapiChBChecked"
add_subdirectory(milo/mrestapi)
@endif
@if "%{msentryCheckBox}" == "msentryChBChecked"
add_subdirectory(milo/msentry)
@endif
@if "%{msshtunnelCheckBox}" == "msshtunnelChBChecked"
add_subdirectory(milo/msshtunnel)
@endif
@if "%{memailsystemCheckBox}" == "memailsystemChBChecked"
add_subdirectory(milo/memailsystem)
@endif
@if "%{mcalendarCheckBox}" == "mcalendarChBChecked"
add_subdirectory(milo/mcalendar)
@endif
@if "%{mdatabaseCheckBox}" == "mdatabaseChBChecked"
add_subdirectory(milo/mdatabase)
@endif

set(SOURCES
  src/utils/tags.h
  src/utils/helpers.h
  src/utils/qmlhelpers.cpp src/utils/qmlhelpers.h
)

list(APPEND RESOURCES
  qml/qml.qrc
  resources/resources.qrc
)

set(OTHER_FILES
  README.md
  Release.md
  AUTHORS.md
  LICENSE-MiloCodeDB.txt
  license-Qt.txt
  Doxyfile.in
  .clang-format
  .gitignore
  .gitlab-ci.yml
)

# TODO: add options to enable asan, msan, tsan and ubsan. See .pro file for
# example flags.

# Create LIBRARY with whole application code. It will be used in app executable
# and also in tests

add_library(project-lib STATIC ${SOURCES})

target_include_directories(project-lib
  PUBLIC
  $<INSTALL_INTERFACE:include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
)

target_compile_options(project-lib PRIVATE
  $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
    -Werror -Wall -Wextra -Wconversion -Wsign-conversion -pedantic-errors -Wno-gnu-zero-variadic-macro-arguments -fPIC>
  $<$<CXX_COMPILER_ID:MSVC>:
    /WX /W3>
)

# Use LIBRARY in app executable
if(ANDROID)
  add_library(${PROJECT_NAME} SHARED src/main.cpp ${RESOURCES} ${OTHER_FILES})
else()
  if (WIN32)
    add_executable(${PROJECT_NAME} WIN32 src/main.cpp ${RESOURCES} ${OTHER_FILES})
  elseif(APPLE)
    add_executable(${PROJECT_NAME} MACOSX_BUNDLE src/main.cpp ${RESOURCES} ${OTHER_FILES})
  else()
    add_executable(${PROJECT_NAME} src/main.cpp ${RESOURCES} ${OTHER_FILES})
  endif()
endif()

target_compile_definitions(${PROJECT_NAME}
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

# MCharts are intentionally left out because they don't provide a library
# (it's only a QRC resource)
target_link_libraries(project-lib
@if "%{mlogCheckBox}" == "mlogChBChecked"
  mlog
@endif
@if "%{mbarcodescannerCheckBox}" == "mbarcodescannerChBChecked"
  mbarcodescanner
@endif
@if "%{mconfigCheckBox}" == "mconfigChBChecked"
  mconfig
@endif
@if "%{mcryptoCheckBox}" == "mcryptoChBChecked"
  mcrypto
@endif
@if "%{mrestapiCheckBox}" == "mrestapiChBChecked"
  mrestapi
@endif
@if "%{msentryCheckBox}" == "msentryChBChecked"
  msentry
@endif
@if "%{msshtunnelCheckBox}" == "msshtunnelChBChecked"
  msshtunnel
@endif
@if "%{memailsystemCheckBox}" == "memailsystemChBChecked"
  memailsystem
@endif
@if "%{mcalendarCheckBox}" == "mcalendarChBChecked"
  mcalendar
@endif
@if "%{mdatabaseCheckBox}" == "mdatabaseChBChecked"
  mdatabase
@endif
  Qt${QT_VERSION_MAJOR}::Core
)

target_link_libraries(${PROJECT_NAME}
  project-lib
  Qt${QT_VERSION_MAJOR}::Gui
  Qt${QT_VERSION_MAJOR}::Quick
)

## Deployment configuration
#
# More info:
# https://cmake.org/cmake/help/latest/module/CPack.html#variable:CPACK_PACKAGE_DESCRIPTION
SET(CPACK_GENERATOR "7Z")
SET(PACKAGE_EXTENSIONS "") # "7z" "sha512", etc.
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR "${COMPANY_NAME}")
set(CPACK_PACKAGE_CONTACT "${COMPANY_NAME}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Package description (title, brief)")
set(CPACK_PACKAGE_DESCRIPTION "Package description (contents - long)")
set(CPACK_PACKAGE_HOMEPAGE_URL "${COMPANY_DOMAIN}")
set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.png")
# Welcome image used by some installers on macOS and Windows
#set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_SOURCE_DIR}/resources/")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.md")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_PACKAGE_CHECKSUM "SHA512")
# This generates Start Menu entries with format "executable;Start menu name"
set(CPACK_PACKAGE_EXECUTABLES "${PROJECT_NAME};${PROJECT_NAME}")
set(CPACK_STRIP_FILES ON)

# Here you can modify the package name
#set(CPACK_PACKAGE_FILE_NAME "")
# Here you can modify subfolder below installation prefix - used by some \
# generators (NSIS)
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PROJECT_NAME}")

## Platforms
if(WIN32)
  include(platforms/windows/windows.cmake)
endif()

if(ANDROID)
  include(platforms/android/android.cmake)
else()
  if(UNIX)
    if(APPLE)
      include(platforms/mac/mac.cmake)
    else()
      include(platforms/linux/linux.cmake)
    endif()
  endif()
endif()

## Documentation
configure_file(Doxyfile.in Doxyfile NEWLINE_STYLE UNIX)
find_package(Doxygen REQUIRED dot OPTIONAL_COMPONENTS mscgen dia)

if (DOXYGEN_FOUND)
  add_custom_target(
    doc
    COMMAND Doxygen::doxygen ${CMAKE_BINARY_DIR}/Doxyfile
    COMMAND ${CMAKE_COMMAND} -E tar "cv" "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}-doc.7z"
      --format=7zip "${CMAKE_CURRENT_SOURCE_DIR}/doc/html"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  )

  list(APPEND PACKAGE_EXTENSIONS "7z")
else()
  message(WARNING "Doxygen has not been found. 'doc' target is not available!")
endif()

message("CPack generators are: ${CPACK_GENERATOR}")
message("Extensions uploaded to Seafile are: ${PACKAGE_EXTENSIONS}")

include(CPack)

## Upload to Seafile
# This code generates a set of targets for upload to Seafile. Targets do not
# have any preset dependency but should be run *after* CPack (after call to
# 'make package').
#
# For example on Linux ${PACKAGE_EXTENSIONS} are set to "deb rpm" and as
# a result, targets "upload_deb" and "upload_rpm" will be available, on Windows
# there is "upload_exe" and on macOS there is "upload_dmg".
#
# Upload script requires 3 environment variables to be set:
# - SEAFILE_TOKEN - Seafile API access token
# - SEAFILE_SERVER - Seafile server URL
# - SEAFILE_REPOSITORY_ID - ID of the repository (library) to upload to
#
if(DEFINED ENV{SEAFILE_TOKEN})
  # Upload each of generated packages
  foreach(EXTENSION ${PACKAGE_EXTENSIONS})
    add_custom_target(
      upload_${EXTENSION}
      COMMAND "${CMAKE_COMMAND}"
        -D NAME_BASE=${PROJECT_NAME}
        -D EXTENSION=${EXTENSION}
        -D BIN_DIR=${CMAKE_BINARY_DIR}
        -D BUILD_DATE=${BUILD_DATE}
        -P "${CMAKE_CURRENT_SOURCE_DIR}/milo/mscripts/seafile/upload.cmake"
      COMMENT "Renaming and uploading ${EXTENSION} packages"
      VERBATIM
      USES_TERMINAL
    )
  endforeach()
else()
  message("Not uploading to Seafile because SEAFILE_TOKEN is empty")
endif()
