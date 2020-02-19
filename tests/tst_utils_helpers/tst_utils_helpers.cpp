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

#include <QtTest>
#include <QObject>
#include <QList>
#include <QString>

#include "utils/helpers.h"

class TestUtilsHelpers : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void testCheckMacro();
    void testIndexCheck();
    void cleanupTestCase();
};

void TestUtilsHelpers::initTestCase()
{
}

void TestUtilsHelpers::testCheckMacro()
{
    QObject dummyObject;
    CHECK(connect(&dummyObject, &QObject::objectNameChanged,
                  &dummyObject, &QObject::setObjectName));
}

void TestUtilsHelpers::testIndexCheck()
{
    const QList<QString> list = { "just", "some", "test", "strings" };
    QVERIFY(Helpers::isValidIndex(1, list));
    QVERIFY(Helpers::isValidIndex(4, list) == false);
}

void TestUtilsHelpers::cleanupTestCase()
{
}

QTEST_MAIN(TestUtilsHelpers)

#include "tst_utils_helpers.moc"
