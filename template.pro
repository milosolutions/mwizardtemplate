CONFIG += tests

TEMPLATE = subdirs

docs {
    message("Updating doxygen file. No compilation will be performed!")
    doxy.input = $$PWD/%{ProjectName}.doxyfile.in
    doxy.output = $$PWD/%{ProjectName}.doxyfile
    QMAKE_SUBSTITUTES += doxy
} else {
    SUBDIRS += %{ProjectName} \\

    tests {
        !android {
            CONFIG(debug, debug|release) {
                message("Running test suite")
                SUBDIRS += tests \\
            }
        }
    }
}
