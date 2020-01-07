
unix {
    CONFIG += deploy-autodetect
    debianize {
        CONFIG -= deploy-autodetect
    }
    rpmize {
        CONFIG -= deploy-autodetect
    }
}

no-deploy {
    CONFIG -= deploy-autodetect
    CONFIG -= debianize
    CONFIG -= rpmize
}

deploy-autodetect {
    message( "Deployment using auto detect...")
    isEmpty( DISTRO) {
        include( distroDetection.pri)
        DISTRO = $$detectDistribution()
    }

    equals(DISTRO, "debian") {
        CONFIG += debianize
    }
    equals(DISTRO, "ubuntu") {
        CONFIG += debianize
    }
    equals(DISTRO, "centos") {
        QMAKE_LFLAGS -= -no-pie
        CONFIG += rpmize
    }
    equals(DISTRO, "rhel") {
        QMAKE_LFLAGS -= -no-pie
        CONFIG += rpmize
    }
}

debianize {
    include( debianize.pri)
}

rpmize {
    include( rpmize.pri)
}
