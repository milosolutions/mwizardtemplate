defineReplace(detectDistribution) {
    # Detect Linux distro

    # CentOS issue with /etc/issue - agetty populates that upon login, cat it and
    # there is no info about release, check for /etc/os-release

    # by default use /etc/os-release, fallback to /etc/-issue if file dont exists

    # NOTE: /etc/os-release depending on distro it can have either ID="distro" or
    #       ID=distro (with or without quotation)

    if (exists( "/etc/os-release")) {
        # known IDs
        # debian, centos, ubuntu
        message( "Using /etc/os-release to guess distribution ....")
        DISTRO = $$system(cat /etc/os-release | grep -o -P \\'(?<=^ID=).*\\')
    } else {
        message( "Using /etc/issue to gues distribution ....")
        DISTRO = $$system(cat /etc/issue | cut -d\\' \\' -f1)
    }

    isEmpty( DISTRO) {
        error( "Distro detection failed...")
    }

    DISTRO = $$lower( $$DISTRO)
    DISTRO = $$replace( DISTRO, '"', '')

    # sanity check
    SUPP_DISTROS += debian ubuntu rhel centos

    !contains( SUPP_DISTROS, $$DISTRO) {
        error( "Detected distro ->"$$DISTRO"<- is not on supported list supported distros:" $$SUPP_DISTROS)
    }

    message( "Distribution detected as:" $$DISTRO)

    return($${DISTRO})
 }

