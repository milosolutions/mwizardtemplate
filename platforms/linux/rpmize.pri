# RPMize build
# run rpmbuild (availabel on Cent / Deb based) after target linkage, after compilation is done
# NOTE: PWD is one that %{ProjectName}.pro is located in for shell cmd
# NOTE: root dir is custom, on Suse/RedHat it's: /usr/src/redhat, /usr/src/packages, /user/rpmbuild
# NOTE: rpm don't contains src code! If it's desired then modification is required
#       and rpmbuild will compile

## prebuild step, prepare initial file structure, make substitute for control

OTHER_FILES += \\
    platforms/linux/app.spec.in

RPM_ROOT=$${APP_NAME}_$${VERSION}

# substitute will auto create $$RPM_ROOT dir
RSUMMARY = "%{ProjectName}"
RAPPNAME = $${APP_NAME}
RAPPVERSION = $${VERSION}
RRELEASE = 0
RLICENSE = "%{ProjectName} Licence"
RBUILDARCH = x86_64
RGROUP = Development/Tools
RVENDOR = $${COMPANY_NAME} $${COMPANY_DOMAIN}
#RREQUIRES = "qt5-qtbase, qt5-qtbase-gui"
# GUI dependencies:
RREQUIRES = "qt5-qtbase, qt5-qtbase-gui"
RDESCRIPTION = "%{ProjectName} application."
# TODO: add support for changelog, i.e. reading CHANGLELOG file or other approach
RCHANGELOG = ""

# NOTE: spec needs to have LF end lines, not CRLF
rpmSpec.input = ./platforms/linux/app.spec.in
rpmSpec.output = $$RPM_ROOT/SPECS/app.spec
QMAKE_SUBSTITUTES += rpmSpec

PCKG_NAME = $${APP_NAME}-$${VERSION}-$${RRELEASE}.$${RBUILDARCH}

include( "desktopEntry.pri")

## post build step, rpmbuild

# NOTE: each command needs to be separated by new line
NL = $$escape_expand(\\n\\t)

RPM_ROOT_ABS = $$absolute_path($$RPM_ROOT, .)

!contains($${PWD}, $${OUT_PWD}) {
    # make absolute path for shadow builds
    # rpmbuild require abs path
    RPM_ROOT_ABS = $${OUT_PWD}/$$RPM_ROOT
}

message ("RPM_ROOT_ABS:" $${RPM_ROOT_ABS})

# create RPM custom build struct

# NOTE: use mkdir -p to ignore error on directory already existing
#       this error will be triggered on normal development, one time compilation
#       is not affected

QMAKE_POST_LINK += cd ./$$RPM_ROOT $$NL
QMAKE_POST_LINK += mkdir -p ./$$RPM_ROOT/BUILD $$NL
QMAKE_POST_LINK += mkdir -p ./$$RPM_ROOT/BUILDROOT $$NL
QMAKE_POST_LINK += mkdir -p ./$$RPM_ROOT/RPMS $$NL
QMAKE_POST_LINK += mkdir -p ./$$RPM_ROOT/SOURCES $$NL
QMAKE_POST_LINK += mkdir -p ./$$RPM_ROOT/SRPMS $$NL

# cp binaries to appropriate location on rpm build dirrectory
QMAKE_POST_LINK += mkdir -p ./$$RPM_ROOT/BUILDROOT/$$PCKG_NAME/usr/local/bin $$NL
QMAKE_POST_LINK += mkdir -p ./$$RPM_ROOT/BUILDROOT/$$PCKG_NAME/usr/share/pixmaps $$NL
#QMAKE_POST_LINK += cp $$_PRO_FILE_PWD_/resources/img/icon.png ./$$RPM_ROOT/BUILDROOT/$$PCKG_NAME/usr/share/pixmaps/%{ProjectName}.png $$NL
QMAKE_POST_LINK += cp ./build/bin/$$TARGET ./$$RPM_ROOT/BUILDROOT/$$PCKG_NAME/usr/local/bin/$$TARGET $$NL

# work around srouces issue, create empty src tar.gz file
#QMAKE_POST_LINK += touch ./$$RPM_ROOT/SOURCES/$${APP_NAME}.tar.gz $$NL

# Specify custom root dir by either: rpmbuild –buildroot or env var %_topdir
# using --buildroot don't work for some reason, maybe macro overrides it
# using current dir as build dir, with is now ./$$RPM_ROOT
QMAKE_POST_LINK += rpmbuild -v -bb --define \\"_topdir $$RPM_ROOT_ABS\\" --target=x86_64 $$RPM_ROOT_ABS/SPECS/app.spec $$NL

# cp rpm
QMAKE_POST_LINK += cp ./$$RPM_ROOT/RPMS/$$RBUILDARCH/*.rpm ./ $$NL

# TODO: Package signing using GPG

message("Using extra compiler RPMize to generate *.rpm package...")

# adds dummy compiler to perform clean up action
# NOTE: issue with version change between compiles, no clean up for old one
# NOTE: Substitute issue, this clean up will FORCE QMAKE !
DUMMY_F = .
cleanUp.input            = DUMMY_F
cleanUp.output          += ${QMAKE_FILE_BASE}
cleanUp.name             = running clean Up
cleanUp.clean           += ./$${PCKG_NAME}.rpm
# FORCE qmake to process QMAKE_SUBSTITUTES step
# sideeffect, when doing rebuild, qmake will be invoked, this is workaround for
# QtCreator and development
cleanUp.clean           += ./Makefile
cleanUp.clean_commands  += rm -r $$RPM_ROOT
cleanUp.commands         = ${QMAKE_FILE_IN}
cleanUp.config          += no_link target_predeps
cleanUp.variable_out     = DUMMY_OUT

!build_pass:QMAKE_EXTRA_COMPILERS *= cleanUp
