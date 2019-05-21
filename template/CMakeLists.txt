set(SOURCES
  src/main.cpp
)

set(RESOURCES
  qml/qml.qrc
  resources/resources.qrc
)

set(OTHER_FILES
  ../README.md
  ../Release.md
  ../AUTHORS.md
  ../LICENSE-MiloCodeDB.txt
  ../license-Qt.txt
  ../%{ProjectName}.doxyfile
  ../.clang-format
  ../.gitignore
  ../.gitlab-ci.yml
)

# Create the application
add_executable(%{ProjectName} ${SOURCES} ${RESOURCES} ${OTHER_FILES})

# Link to Cutelyst
target_link_libraries(%{ProjectName}
    Qt5::Core
)
