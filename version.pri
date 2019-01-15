# Provide version number to application
COMMIT = $$system(git rev-parse --short HEAD)

VERSION=0.0.1

HOST_MACHINE = $$[QMAKE_SPEC]
contains (HOST_MACHINE, .*win32.*) {
    BUILD_DATE=$$system(powershell -Command "Get-Date -format yyyy-MM-dd")
} else {
    BUILD_DATE = $$system(date +%Y-%m-%d)
}

APP_VERSION = "$$VERSION"
APP_NAME = "%{ProjectName}"
COMPANY_NAME = "Milo Solutions"
COMPANY_DOMAIN = "milosolutions.com"

# add defines
DEFINES += AppVersion='"\\\\\\"$$APP_VERSION\\\\\\""'
DEFINES += AppName='"\\\\\\"$$APP_NAME\\\\\\""'
DEFINES += CompanyName='"\\\\\\"COMPANY_NAME\\\\\\""'
DEFINES += CompanyDomain='"\\\\\\"COMPANY_DOMAIN\\\\\\""'
DEFINES += BuildDate=\\\\\\"$$BUILD_DATE\\\\\\"
DEFINES += GitCommit=\\\\\\"$$COMMIT\\\\\\"

# To use VERSION in non-Qt files, use QMAKE_SUBSTITUTES:
# manifest.input = $$PWD/some/%{ProjectName}.xml.in
# manifest.output = $$PWD/some/output.xml
# QMAKE_SUBSTITUTES += manifest
