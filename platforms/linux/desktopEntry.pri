# NOTE: by default .desktop resides in /usr/share/applications
#       to modify by user cp to ~/.local/share/applications and
#       ~/.local/share/applications copy will be taken as
#       "current" / effective

isEmpty( DISTRO) {
    include( distroDetection.pri)
    DISTRO = $$detectDistribution()
}

deploy-autodetect {
    equals(DISTRO, "debian") {
        ROOT_B_DIR=$$DEB_ROOT
    }
    equals(DISTRO, "ubuntu") {
        ROOT_B_DIR=$$DEB_ROOT
    }
    equals(DISTRO, "centos") {
        ROOT_B_DIR=$$RPM_ROOT/BUILDROOT/$$PCKG_NAME
    }
    equals(DISTRO, "rhel") {
        ROOT_B_DIR=$$RPM_ROOT/BUILDROOT/$$PCKG_NAME
    }
}

debianize {
    ROOT_B_DIR=$$DEB_DIR
}

rpmize {
    ROOT_B_DIR=$$RPM_ROOT/BUILDROOT/$$PCKG_NAME
}

isEmpty( ROOT_B_DIR) {
    error( "Build root path is empty...")
}

EXECUTABLE_LOC="$$TARGET"

desktopShortcut.input = ./platforms/linux/app.desktop.in
desktopShortcut.output = $$ROOT_B_DIR/usr/share/applications/%{ProjectName}.desktop
QMAKE_SUBSTITUTES += desktopShortcut
