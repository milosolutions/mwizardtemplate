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


string(APPEND CPACK_GENERATOR ";DEB;RPM")
list(APPEND PACKAGE_EXTENSIONS "deb" "rpm")

## Debian
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/deb.html
SET(CPACK_DEB_COMPONENT_INSTALL OFF)
SET(CPACK_DEBIAN_COMPRESSION_TYPE "xz")
SET(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT")
# https://www.debian.org/doc/debian-policy/ch-archive.html#s-subsections
SET(CPACK_DEBIAN_PACKAGE_SECTION "devel")
#SET(CPACK_DEBIAN_PACKAGE_GENERATE_SHLIBS ON)
#SET(CPACK_DEBIAN_PACKAGE_GENERATE_SHLIBS_POLICY ">=")

# libqt5widgets5, libqt5qml5, libqt5quick5, etc.
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libqt5core5a, libqt5gui5")

# RPM
# More info:
# https://cmake.org/cmake/help/latest/cpack_gen/rpm.html
SET(CPACK_RPM_COMPONENT_INSTALL OFF)
SET(CPACK_RPM_COMPRESSION_TYPE "xz")
SET(CPACK_RPM_FILE_NAME "RPM-DEFAULT")
SET(CPACK_RPM_PACKAGE_DESCRIPTION "${CPACK_PACKAGE_DESCRIPTION}")
#SET(CPACK_RPM_PACKAGE_LICENSE "")
