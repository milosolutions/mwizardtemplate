# Deployment controls. Deployment is disabled by default
no-deploy {
    message("Disabling deployment")
    CONFIG -= deploy-autodetect
    CONFIG -= debianize
    CONFIG -= rpmize
}

unix {
    debianize {
        CONFIG -= deploy-autodetect
    }

    rpmize {
        CONFIG -= deploy-autodetect
    }
}

deploy-autodetect {
    message("Automatically detecting deployment method")

    isEmpty(DISTRO) {
        include(distroDetection.pri)
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
    message("Deploying DEBIAN packages")
    include(debianize.pri)
} else:rpmize {
    message("Deploying RPM packages")
    include(rpmize.pri)
} else {
    message("NO Linux deployment")
}
