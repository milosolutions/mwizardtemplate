# Main qmake configuration file for unit tests

TEMPLATE = subdirs

# Milo Code Database tests:
SUBDIRS += \\
@if "%{msentryCheckBox}" == "msentryChBChecked"
    ../milo/msentry/tst_msentry \\
@endif
@if "%{mrestapiCheckBox}" == "mrestapiChBChecked"
    ../milo/mrestapi/tst_mrestapi \\
@endif
@if "%{mlogCheckBox}" == "mlogChBChecked"
    ../milo/mlog/tst_mlog \\
@endif
@if "%{mcryptoCheckBox}" == "mcryptoChBChecked"
    ../milo/mcrypto/tst_mcrypto \\
@endif
@if "%{mconfigCheckBox}" == "mconfigChBChecked"
    ../milo/mconfig/tst_mconfig \\
@endif
@if "%{mmigrationsCheckBox}" == "mmigrationsChBChecked"
    ../milo/mmigrations/tst_mmigrations \\
@endif

# Add new test cases here:
SUBDIRS += \\
    tst_utils_helpers


# Please use convenience includes:
# testConfig.pri - contains general configs
# helpers/helpers.pri - contains property tester, great for testing QObjects

# Tests can be run in Qt Creator (enable AutoTest plugin, then run tests from
# panel 8). Tests can be run from command line. Just run:
# $ make check
# In build directory (where root Makefile is).
