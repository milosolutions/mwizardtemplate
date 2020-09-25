#install(TARGETS ${PROJECT_NAME}
  #CONFIGURATIONS Release
  #LIBRARY DESTINATION lib
  #RUNTIME DESTINATION ""
#)

#install(FILES someFileYouNeedToDeploy
#  #CONFIGURATIONS Release
#  DESTINATION include/someDir
#)

#install(DIRECTORY directories to deploy
#  #CONFIGURATIONS Release
#  DESTINATION include/someDir
#  PATTERN *.h
#)

## Windows deployment (windeployqt)
# https://qt.programmingpedia.net/en/tutorial/5857/deploying-qt-applications
# Retrieve the absolute path to qmake and then use that path to find
# the binaries
get_target_property(_qmake_executable Qt5::qmake IMPORTED_LOCATION)
get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${_qt_bin_dir}")

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND "${CMAKE_COMMAND}" -E copy
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.exe"
    "${CMAKE_CURRENT_BINARY_DIR}/deployment/${PROJECT_NAME}.exe"
  COMMAND "${CMAKE_COMMAND}" -E
    env PATH="${_qt_bin_dir}" "${WINDEPLOYQT_EXECUTABLE}"
      --qmldir "${CMAKE_SOURCE_DIR}/qml"
      --qmlimport "${CMAKE_SOURCE_DIR}/qml"
      --verbose 1
      "deployment/${PROJECT_NAME}.exe"
  COMMENT "Running windeployqt..."
)

# This installation statement ensures that whole deployment directory (created
# by windeployqt) is put into the package (NSIS, ZIP) by CPack
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/deployment/
  #CONFIGURATIONS Release
  DESTINATION "."
)

# For this to work on Windows, best install:
# * Chocolatey
# * choco install cmake
# * choco install nsis
string(APPEND CPACK_GENERATOR "ZIP;NSIS") #;IFW

## NSIS
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/nsis.html
#SET(CPACK_NSIS_INSTALL_ROOT "c:/Program Files/")
# Clearing default icon because NSIS does not know how to use it...
set(CPACK_PACKAGE_ICON "")
#SET(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.ico")
#SET(CPACK_NSIS_MUI_UNIICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.ico")
#SET(CPACK_NSIS_INSTALLED_ICON_NAME "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.ico")
#SET(CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.bmp")
#SET(CPACK_NSIS_MUI_UNWELCOMEFINISHPAGE_BITMAP "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.bmp")
#SET(CPACK_NSIS_MUI_HEADERIMAGE "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.bmp")
SET(CPACK_NSIS_COMPRESSOR "lzma")
SET(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_NAME}")
SET(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
SET(CPACK_NSIS_URL_INFO_ABOUT "${COMPANY_DOMAIN}")
SET(CPACK_NSIS_MUI_FINISHPAGE_RUN "${CPACK_PACKAGE_NAME}.exe")


## Qt Installer Framework (IFW)
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/ifw.html
