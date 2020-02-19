# Sets up a single unit test
macro(setUpTest name)
    find_package(Qt5 COMPONENTS REQUIRED Core Test)

    target_include_directories(${name} PUBLIC
      $<TARGET_PROPERTY:project-lib,INCLUDE_DIRECTORIES>
    )

    target_link_libraries(${name}
      project-lib
      Qt5::Core
      Qt5::Test
    )

    add_test(${name} ${name})
endmacro()
