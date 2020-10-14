# Milo base project template

[Source code](https://github.com/milosolutions/newprojecttemplate)

# Intro

* minimal Qt version is Qt 5.9. Recommended: newest available
* minimal C++ standard is C++14 (C++17 is recommended)

New project template contains basic Qt application scaffolding, good for
all types of applications: console, widget and QML apps.

This README aims to help you get started with MCDB.
**Remove it when you don't need it anymore in your project.**

The MCDB readme can always be accessed
[online](https://github.com/milosolutions/mwizardtemplate/blob/master/README.md).

## File structure

After installation, you will notice that MCDB neatly organises your files.

* doc - here doxygen will put the documentation of your project
* milo - this folder contains all Milo Code DB submodules. Each module contains
a .pri and CMakeLists.txt files - depending on which build system you are using
* tests - put all unit tests here. They will be picked up by Qt Creator
automatically when you open your main .pro file
(located in `_project name_/_project name_.pro`)
* `Doxyfile.in` - doxygen configuration template file. Use it to
set up and build the documentation for your project. Milo submodules each have a
doxyfile as well, so you can easily combine them (via doxytags).
The .in file is transformed into a real doxygen configuration file when you run
`qmake CONFIG+=docs` - it will fill in the proper version string
* `AUTHORS.md` - specify who writes your project. Useful in FOSS projects when
you need to change license or compile a list of credits. You can remove this
file if you don't need it
* `README.md` - the readme for your project. Please replace the contents
with your own
* `Release.md` - here you should put info how to build the project and prepare
release packages
* `.gitlab-ci.yml` - example CI file for GitLab. Adapt it to your needs or throw
it away if you are not using GitLab CI
* `.gitignore` - default gitignore file. Feel free to modify
* `LICENSE-MiloCodeDB.txt` - license under which MCDB is distributed. It does
not apply to your code, only to the template code from MCDB
* `license-Qt.txt` - LGPL license under which Qt is distributed. This is only
included so that you don't forget about your LGPL obligations when creating a Qt
project
* `LICENSE.md` - the license for all remaining project code (your code). Make
sure to provide proper licensing information here
* `_project name_.pro` - main .pro file
* `CMakeLists.txt` - main cmake file

## Setup

If you have installed MCDB from the official installer, or added some MCDB
modules via git, there are some actions you need to take to set it all up
properly.

1. Open the .pro file and check if all submodules are added, check if config is
correct. Each MCDB submodules comes with a handy .pri file that you can add
to your main .pro. If you are using `cmake` (you should!), submodules are added
using `add_subdirectory`.
2. Open `Release.md` file and fill it with information on how to release a package
of your software for each platform. This will help other team members to deploy
your solution.
3. Check the doxygen file, update it to fit your project.
4. Use `version.cmake` or `version.pri` to manage your software version. This
will be used throughout the project (in documentation, installers, C++ code) as
the central information about project version.

# Milo Code Database:

Other subprojects can add more goodies to this template. Please check out
[the docs](https://docs.milosolutions.com/milo-code-db/milo-qtcreator-wizard/md_doc_subprojects.html).

# License

Milo Code DB is licensed under the MIT License - see the
`LICENSE-MiloCodeDB.txt` file for details. The license of remaining code (what
you write) is not governed by MCDB, you can add your own `LICENSE.md` file for
your code.
