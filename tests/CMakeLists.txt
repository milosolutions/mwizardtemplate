
project(tests
  VERSION ${PROJECT_VERSION}
  DESCRIPTION "Tests"
  LANGUAGES CXX
)

set(OTHER_FILES README-tests.md)

# Milo Code Database unit tests are located in their own directories

# Project tests:
add_subdirectory(tst_utils_helpers)

# To add a new unit test, copy one of the existing ones (like tst_utils_helpers)
# and adjust it to your needs.
