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

## macOS deployment (macdeployqt)
# https://qt.programmingpedia.net/en/tutorial/5857/deploying-qt-applications
# Retrieve the absolute path to qmake and then use that path to find
# the binaries
get_target_property(_qmake_executable Qt5::qmake IMPORTED_LOCATION)
get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS "${_qt_bin_dir}")

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND "${MACDEPLOYQT_EXECUTABLE}"
        "$<TARGET_FILE_DIR:${PROJECT_NAME}>/../.."
        -always-overwrite
    COMMENT "Running macdeployqt..."
)

string(APPEND CPACK_GENERATOR "DragNDrop;Bundle")

## macOS DMG (DragNDrop)
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/dmg.html
#SET(CPACK_DMG_BACKGROUND_IMAGE "")

## macOS Bundle
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/bundle.html
# This one is REQUIRED!
#SET(CPACK_BUNDLE_NAME "")
# This one is REQUIRED!
#SET(CPACK_BUNDLE_PLIST ".plist")
#SET(CPACK_BUNDLE_APPLE_CERT_APP "Developer ID Application: [Name]")
#SET(CPACK_BUNDLE_APPLE_ENTITLEMENTS "something.plist")
#SET(CPACK_BUNDLE_APPLE_CODESIGN_FILES "extra;files")
