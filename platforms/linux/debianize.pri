# Debianize build
# run debianize after target linkage, after compilation is done
# NOTE: PWD is one that PRO is located in for shell cmd

# Deployment NOTE:
#   On Debian, when application directory is "non-standard", i.e. /opt, and
#   yes apparently on Debian standard is /usr, when removing package it will
#   also DELETE root directory, i.e. /opt, if no files reside in that dir.
#   This is known Debian issue.

OTHER_FILES += \\
    platforms/linux/control.in

## prebuild step, prepare initial file structure, make substitute for control

DEB_ROOT=$${APP_NAME}_$${VERSION}
DEB_DIR=deb_build

isEmpty(DISTRO) {
    include(distroDetection.pri)
    DISTRO = $$detectDistribution()
}

# substitute will auto create $$DEB_ROOT dir
DAPPNAME = $${APP_NAME}
DAPPVERSION = $${VERSION}
DSECTION = "base"
DPRIORITY = "optional"
#DDEPENDS = "libqt5core5a, libqt5gui5, libqt5widgets5"
DDEPENDS = "libqt5core5a"

DMAINTANER = $${COMPANY_NAME} $${COMPANY_DOMAIN}
# NOTE: new line needs to start with space !
DESCRIPTION = " %{ProjectName} application."

debControl.input = ./platforms/linux/control.in
debControl.output = $$DEB_DIR/DEBIAN/control
QMAKE_SUBSTITUTES += debControl

include("desktopEntry.pri")

## post build step, dpkg

# NOTE: each command needs to be separated by new line
NL = $$escape_expand(\\n\\t)

# NOTE: use mkdir -p to ignore error on directory already existing
#       this error will be triggered on normal development, one time compilation
#       is not affected

QMAKE_POST_LINK += echo "Preparing DEB package" $$NL
QMAKE_POST_LINK += cd ./$$DEB_DIR $$NL

#QMAKE_POST_LINK += mkdir -p ./$$DEB_DIR/usr/share/pixmaps $$NL
QMAKE_POST_LINK += mkdir -p ./$$DEB_DIR/usr/bin $$NL
#QMAKE_POST_LINK += cp $$_PRO_FILE_PWD_/resources/img/icon.png ./$$DEB_DIR/usr/share/pixmaps/%{ProjectName}.png $$NL
QMAKE_POST_LINK += cp ./build-$${QT_ARCH}/bin/$${TARGET} ./$$DEB_DIR/usr/bin/$${TARGET} $$NL

QMAKE_POST_LINK += dpkg-deb --build ./$$DEB_DIR ./$$DEB_ROOT.deb

message("Using extra compiler debianize to generate *.deb package...")

# adds dummy compiler to perform clean up action
# NOTE: issue with version change between compiles, no clean up for old one
# NOTE: Substitute issue, this clean up will FORCE QMAKE !
DUMMY_F = .
cleanUp.input            = DUMMY_F
cleanUp.output          += ${QMAKE_FILE_BASE}
cleanUp.name             = running clean Up
cleanUp.clean           += ./$${DEB_ROOT}_amd64.deb
# FORCE qmake to process QMAKE_SUBSTITUTES step
# sideeffect, when doing rebuild, qmake will be invoked, this is workaround for
# QtCreator and development
cleanUp.clean           += ./Makefile
cleanUp.clean_commands  += rm -r $${DEB_DIR}
cleanUp.commands         = ${QMAKE_FILE_IN}
cleanUp.config          += no_link target_predeps
cleanUp.variable_out     = DUMMY_OUT

!build_pass:QMAKE_EXTRA_COMPILERS *= cleanUp
