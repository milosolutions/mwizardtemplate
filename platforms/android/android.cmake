## Android deployment is managed by Qt automatically
# See the main CMakeLists.txt file for more info

list(APPEND PACKAGE_EXTENSIONS "apk")

# Android does not require custom CPACK step, but we copy the APK to make sure
# Seafile uploader can find it.

option(force_debug_apk "Always copy APK from debug dir" OFF)

if (("${CMAKE_BUILD_TYPE}" STREQUAL "Debug") OR (force_debug_apk))
  SET(BUILD_TYPE "debug")
else()
  SET(BUILD_TYPE "release")
endif()

# -signed
add_custom_command(
  TARGET apk POST_BUILD
  COMMAND "${CMAKE_COMMAND}" -E echo "Build type is: ${CMAKE_BUILD_TYPE} ${BUILD_TYPE}"
  COMMAND "${CMAKE_COMMAND}" -E copy
    "${CMAKE_CURRENT_BINARY_DIR}/android-build/build/outputs/apk/${BUILD_TYPE}/*.apk"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${CMAKE_PROJECT_VERSION}.apk"
  COMMENT "Copying APK"
)
