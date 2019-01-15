INCLUDEPATH += $$PWD

mac:!ios {
    ICON = $$PWD/%{ProjectName}.icns
    QMAKE_INFO_PLIST = $$PWD/Info.plist
}
