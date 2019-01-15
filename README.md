[TOC]

Milo Code DB main ([online](https://docs.milosolutions.com/milo-code-db/main/) | [offline](\ref milodatabasemain))

[Source code](https://github.com/milosolutions/newprojecttemplate)

# Intro

Minimal Qt version is Qt 5.5. Recommended: newest available.

New project template contains basic Qt application scaffolding, good for
all types of applications: console, widget and QML apps.

This README aims to help you get started with MCDB. Feel free to remove it when
you don't need it anymore in your project. The MCDB readme can always be
accessed [online](https://docs.milosolutions.com/milo-code-db/newprojecttemplate/).

## File structure

After installation, you will notice that MCDB neatly organises your files.

* doc - here doxygen will put the documentation of your project
* milo - this folder contains all Milo Code DB submodules. Each module contains
a .pri file. Include it in your .pro, and the submodule will become active. The
MCDB installer does this automatically for you
* _project name_ - this is where your source code should go. It contains platform
includes, application's main.pro file, main.cpp and stubs for QML and resources
(if not needed, remove them)
* tests - put all unit tests here. They will be picked up by Qt Creator
automatically when you open your main .pro file
(located in _project name_/_project name_.pro)
* _project name_.doxyfile - doxygen configuration file. Use it to set up and
build the documentation for your project. Milo submodules each have a doxyfile
as well, so you can easily include them (via doxytags)
* AUTHORS.md - specify who writes your project. Useful in FOSS projects when
you need to change license or compile a list of credits. You can remove this
file if you don't need it
* README.md - the readme for your project. Feel free to replace the contents
with your own
* Release.md - here you should put info how to build the project and prepare
release packages
* .gitlab-ci.yml - example CI file for GitLab. Adapt it to your needs or throw
it away if you are not using GitLab CI
* .gitignore - default gitignore file. Feel free to modify
* LICENSE-MiloCodeDB.txt - license under which MCDB is distributed. It does not
apply to your code
* license-Qt.txt - LGPL license under which Qt is distributed. This is only
included so that you don't forget about your LGPL obligations when creating a Qt
project
* _project name_.pro - main .pro file. It is a subdirs project, which defines
unit test targets and your concrete project. For main .pro of your application,
see _project name_/_project name_.pro instead

## Setup

If you have installed MCDB from the official installer, or added some MCDB
modules via git, there are some actions you need to take to set it all up
properly.

1. Open the .pro file and check if all submodules are added, check if config is
correct etc. Each MCDB submodules comes with a handy .pri file that you can add
to your main .pro.
2. Open Release.md file and fill it with information on how to release a package
of your software for each platform. This will help other team members to deploy
your solution.
3. Check the doxygen file, update it to fit your project.
4. Use milo/mscripts/version to manage your software version. There is a script
there for bumping the version string in all config files for all platforms.

## Optional items:

1. Add CI to your project (see MScripts repository in Milo Code Database).

# Milo Code Database:

Other subprojects can add more goodies to this template. Please check out
[the docs](https://docs.milosolutions.com/milo-code-db/main/subprojects.html).

# 3rd party libraries 

* [create-dmg](https://github.com/andreyvit/create-dmg) - A shell script to build
fancy DMGs. MIT License.

# License 

Milo Code DB is licensed under the MIT License - see the LICENSE-MiloCodeDB.txt
file for details. The license of remaining code (what you write) is not governed
by MCDB, you can add your own LICENSE file for your code.
