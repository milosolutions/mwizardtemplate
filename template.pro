## Milo Solutions - project file TEMPLATE
#
#
## (c) Milo Solutions, 2016-2019

QT = core

include(version.pri)

# Warning! QStringBuilder can crash your app! See last point here:
# https://www.kdab.com/uncovering-32-qt-best-practices-compile-time-clazy/
# !!!
DEFINES *= QT_USE_QSTRINGBUILDER
QMAKE_CXXFLAGS += -Werror

TEMPLATE = app
CONFIG += c++14

no-ltcg {
    message("Compiling with link time optimizations (LTCG) DISABLED)")
    CONFIG -= ltcg
}

ltcg {
    message("Compiling with link time optimizations (LTCG) ENABLED)")
}

docs {
    message("Updating doxygen file. No compilation will be performed!")
    doxy.input = $$PWD/%{ProjectName}.doxyfile.in
    doxy.output = $$PWD/%{ProjectName}.doxyfile
    QMAKE_SUBSTITUTES += doxy
}


TARGET = %{ProjectName}

HEADERS +=

SOURCES += src/main.cpp 

RESOURCES +=  \\
    qml/qml.qrc \\
    resources/resources.qrc

OTHER_FILES += \\
    %{ProjectName}.doxyfile \\
    README.md \\
    Release.md \\
    .gitignore \\
    license-Qt.txt \\
    .gitlab-ci.yml

## Put all build files into build directory
##  This also works with shadow building, so don't worry!
BUILD_DIR = build
OBJECTS_DIR = $$BUILD_DIR
MOC_DIR = $$BUILD_DIR
RCC_DIR = $$BUILD_DIR
UI_DIR = $$BUILD_DIR
DESTDIR = $$BUILD_DIR/bin

## Platforms
@if "%{WindowsChB}" == "WindowsChBChecked"
include(platforms/windows/windows.pri)
@endif
@if "%{MacChB}" == "MacChBChecked"
include(platforms/mac/mac.pri)
@endif
@if "%{AndroidChB}" == "AndroidChBChecked"
include(platforms/android/android.pri)
@endif

## Modules
@if "%{mbarcodescannerCheckBox}" == "mbarcodescannerChBChecked"
include(milo/mbarcodescanner/mbarcodescanner.pri)
@endif
@if "%{mchartsCheckBox}" == "mchartsChBChecked"
include(milo/mcharts/mcharts.pri)
@endif
@if "%{mconfigCheckBox}" == "mconfigChBChecked"
include(milo/mconfig/mconfig.pri)
@endif
@if "%{mcryptoCheckBox}" == "mcryptoChBChecked"
include(milo/mcrypto/mcrypto.pri)
@endif
@if "%{mlogCheckBox}" == "mlogChBChecked"
include(milo/mlog/mlog.pri)
@endif
@if "%{mrestapiCheckBox}" == "mrestapiChBChecked"
include(milo/mrestapi/mrestapi.pri)
@endif
@if "%{mscriptsCheckBox}" == "mscriptsChBChecked"
include(../milo/mscripts/mscripts.pri)
@endif
@if "%{msentryCheckBox}" == "msentryChBChecked"
include(milo/msentry/msentry.pri)
@endif
