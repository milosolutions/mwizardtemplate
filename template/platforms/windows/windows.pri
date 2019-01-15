INCLUDEPATH += $$PWD

win32 {
exists($$PWD/default.rc) {
   RC_FILE = $$PWD/default.rc
}
}


