install(TARGETS ${PROJECT_NAME}
  #CONFIGURATIONS Release
  #LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

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
    COMMAND "${CMAKE_COMMAND}" -E
        env PATH="${_qt_bin_dir}" "${WINDEPLOYQT_EXECUTABLE}"
            "$<TARGET_FILE:${PROJECT_NAME}>"
    COMMENT "Running windeployqt..."
)

string(APPEND CPACK_GENERATOR "NSIS") #;IFW

## NSIS
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/nsis.html
SET(CPACK_NSIS_INSTALL_ROOT "c:\\Program Files\\")
SET(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.ico")
SET(CPACK_NSIS_MUI_UNIICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.ico")
SET(CPACK_NSIS_INSTALLED_ICON_NAME "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon.ico")
SET(CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP "")
SET(CPACK_NSIS_MUI_UNWELCOMEFINISHPAGE_BITMAP "")
SET(CPACK_NSIS_COMPRESSOR "lzma")
SET(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_NAME}")
SET(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
SET(CPACK_NSIS_URL_INFO_ABOUT "${COMPANY_DOMAIN}")
SET(CPACK_NSIS_MUI_FINISHPAGE_RUN "${CPACK_PACKAGE_NAME}.exe")


## Qt Installer Framework (IFW)
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/ifw.html
