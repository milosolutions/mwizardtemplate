/*******************************************************************************
Copyright (C) 2020 Milo Solutions
Contact: https://www.milosolutions.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*******************************************************************************/


/*
  TEMPLATE main.cpp by Milo Solutions. Copyright 2020
*/

#include <QGuiApplication>
#include <QLoggingCategory>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>

//#include "mlog/mlog.h"
//#include "utils/tags.h"
#include "utils/helpers.h"
#include "utils/qmlhelpers.h"

// Prepare logging categories. Modify these to your needs
//Q_DECLARE_LOGGING_CATEGORY(core) // already declared in MLog header
Q_LOGGING_CATEGORY(coreMain, "core.main")

/*!
  Main routine. Remember to update the application name and initialise logger
  class, if present.
  */
int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    //MLog::instance();
    // Set up basic application data. Modify this to your needs
    QGuiApplication app(argc, argv);
    app.setApplicationVersion(ApplicationVersion);
    app.setOrganizationName(CompanyName);
    app.setOrganizationDomain(CompanyDomain);
    app.setApplicationName("%{ProjectName}");

    // For GUI applications:
    app.setWindowIcon(QIcon("://icon.png"));

    //logger()->setLogLevel(MLog::DebugLog);
    //logger()->enableLogToFile(app.applicationName());
    qCInfo(coreMain) << "\\nName:" << app.applicationName()
                     << "\\nOrganisation:" << app.organizationName()
                     << "\\nDomain:" << app.organizationDomain()
                     << "\\nVersion:" << app.applicationVersion()
                     << "\\nSHA:" << GitCommit
                     << "\\nBuild date:" << BuildDate;

    QQmlApplicationEngine engine;

    auto qmlHelpers = new QmlHelpers(&engine);
    engine.rootContext()->setContextProperty("qmlHelpers", qmlHelpers);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    CHECK(QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                           &app, [url](QObject *obj, const QUrl &objUrl) {
              if (!obj && url == objUrl)
              QCoreApplication::exit(-1);
          }, Qt::QueuedConnection));
    engine.load(url);

    return app.exec();
}
