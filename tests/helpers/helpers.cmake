# Sets up a single unit test
macro(setUpTest name)
    find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Test REQUIRED)

    target_include_directories(${name} PUBLIC
      $<TARGET_PROPERTY:project-lib,INCLUDE_DIRECTORIES>
    )

    target_link_libraries(${name}
      project-lib
      Qt${QT_VERSION_MAJOR}::Core
      Qt${QT_VERSION_MAJOR}::Test
    )

    add_test(${name} ${name})
endmacro()
