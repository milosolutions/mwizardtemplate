Build
=====

To build unit tests, uncomment this line in your local.pri:

~~~
# CONFIG += tests
~~~

Test cases are only tested on Linux - it should be possible to run them on Android/BB, but if you
want it, you're on your own :-)

Run
===

Unit tests can be run in Qt Creator using AutoTest plugin. Just enable it int Help->Plugins, restart
Qt Creator and run tests in the GUI (bottom panel number 8 "Test results").

You can run tests one by one by right clicking on given test case and selecting "Run".

Lastly, you can run whole test suite by calling the following command from the command line:

~~~
make check
~~~

You need to run it from your build directory (where root Makefile is).

If you are building on headless system (no display), you need to redirect rendering to offscreen
platform plugin.

~~~
make check TESTARGS="-platform offscreen"
~~~

~~**WARNING**: Test cases are run with Address Sanitizer by default!~~

Add test case
=============

To add a new test case, see example implementation in miloconf submodule. In short, you need to:

1. Create a new subdir in testModuleName/ directory.
2. Copy .pro file from mconfig/tst_mconfig to your new subdir.
3. Update paths and file names. Make sure ```QT += gui``` is there!
4. Add tst_classname.cpp test case file.
5. Write your tests :-) Remember, you need to cover the base class as good as possible - test basic
functionality, test corner cases, try to break the code.
6. Remember to include config from tets/testConfig.pri.
7. And update .pro file in your tst_moduleName/ directory - to include your new subdir.


Please use convenience includes:
* ```testConfig.pri``` - contains general configs
