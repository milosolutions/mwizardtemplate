install(TARGETS %{ProjectName}
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


string(APPEND CPACK_GENERATOR "DEB;RPM")

SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "${COMPANY_NAME}")
SET(CPACK_DEBIAN_COMPRESSION_TYPE "xz")

# libqt5widgets5, libqt5qml5, libqt5quick5, etc.
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libqt5core5a, libqt5gui5")
