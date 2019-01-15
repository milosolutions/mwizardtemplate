/*******************************************************************************
Copyright (C) 2017 Milo Solutions
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

#pragma once

#include <QByteArray>
#include <QVariant>
#include <QObject>
#include <QMetaObject>
#include <QMetaProperty>
#include <QGenericArgument>
#include <QtTest>

namespace PropertyTester
{
struct Options
{
    //! Object to run tests on
    QObject *object;
    //! Property to test
    QByteArray propertyName;

    //! Should this property have a setter?
    bool hasSetter = true;
    //! Should this property have a getter?
    bool hasGetter = true;
    //! Should this property have a notifier? (signal: propertyNameChanged)
    bool hasNotifier = true;
    //! Unused (for now)
    bool isConst = false;
    //! Should testProperty() return a QSignalSpy?
    bool returnSpy = false;

    //! Read property will be tested using this value
    QVariant getterTestValue;
    //! Write property will be tested using this value
    QVariant setterTestValue;

    // Custom setter
    //! Set to true if you will provide custom setter, instead of WRITE
    //! property
    bool hasCustomSetter = false;
    //! Custom setter name. It has to be a slot or Q_INVOKABLE!
    QByteArray customSetterName;
    QGenericArgument customSetterArg1;
    QGenericArgument customSetterArg2;
};

/*!
 * Tests property defined in \a opts and optionally returns a QSignalSpy object
 * in \a spyReturn.
 *
 * For given property (Options::propertyName), this method will check default
 * value using Options::getterTestValue, then it will use the setter using
 * Options::setterTestValue, and lastly, it will verify that notification signal
 * has been sent.
 *
 * You can modify which parameters are checked using hasSetter, hasGetter,
 * hasNotifier.
 *
 * If you need to check signal spy value later (after this function), you can
 * set returnSpy to true and pass an empty QSignalSpy pointer to \a spyReturn.
 *
 * You can also specify custom setter (if it has more arguments than default
 * one) via hasCustomSetter, customSetterName and customSetterArg*.
 *
 * All values have sane defaults so that it is easiest to test the most common
 * situations.
 *
 * \warning Tested object has to be a QObject subclass, with Q_OBJECT macro
 * defined. And tested property has to be defined using Q_PROPERTY, of course.
 *
 * \note Possibly we could also test Q_GADGETs this way, but more research is
 * needed.
 *
 * Example use:
   \code
    Clipboard clip; // Class to test
    PropertyTester::Options opts;
    opts.object = &clip;
    opts.propertyName = "text";
    opts.getterTestValue = QString();
    opts.setterTestValue = m_text;

    PropertyTester::testProperty(opts);
   \endcode
 */
void testProperty(const Options &opts, QSignalSpy **spyReturn = nullptr)
{
    const auto mo = opts.object->metaObject();
    const QByteArray error(QByteArray("For property: ") + opts.propertyName);
    qInfo() << "Testing property:" << opts.propertyName;

    // Find property
    const int indexOfProperty = mo->indexOfProperty(opts.propertyName.data());
    QVERIFY2(indexOfProperty != -1, error);
    const QMetaProperty property = mo->property(indexOfProperty);

    // Check if getter, setter and signal are defined
    if (opts.hasGetter) {
        QVERIFY2(property.isReadable(), error);
        // Getters are not Q_INVOKABLE
        // const QByteArray getterName(opts.propertyName + "()");
        // QVERIFY2(mo->indexOfMethod(getterName) != -1, error + " | " + getterName);
    }

    if (opts.hasSetter) {
        QVERIFY2(property.isWritable(), error);
        // Setters are not Q_INVOKABLE
        // const QByteArray setterName(QByteArray("set")
        //     + QChar(opts.propertyName.at(0)).toUpper().toLatin1()
        //     + opts.propertyName.mid(1)
        //     + "(" + property.typeName() + ")");
        // QVERIFY2(mo->indexOfMethod(setterName) != -1, error + " | " + setterName);
    }

    if (opts.hasNotifier) {
        QVERIFY2(property.hasNotifySignal(), error);
        QCOMPARE(property.notifySignal().name(), opts.propertyName + "Changed");
    }

    // Construct signal spy. We can't use SIGNAL macro, we have to build the
    // definition manually. "2" is signal in Qt-moc internal language
    const QByteArray signalSignature(QByteArray("2") + property.notifySignal().methodSignature());
    auto spy = new QSignalSpy(opts.object, signalSignature.constData());
    if (opts.hasNotifier)
        QVERIFY2(spy->isValid(), error + signalSignature);

    // Check getter and setter. And check if signal is sent
    QCOMPARE(property.read(opts.object), opts.getterTestValue);
    if (opts.hasSetter) {
        QVERIFY2(property.write(opts.object, opts.setterTestValue), error);
        QCOMPARE(property.read(opts.object), opts.setterTestValue);

        if (opts.hasNotifier) {
            QCOMPARE(spy->count(), 1);
        }
    }

    if (opts.hasCustomSetter) {
        QVERIFY2(opts.object->metaObject()->invokeMethod(opts.object, opts.customSetterName,
                     opts.customSetterArg1, opts.customSetterArg2),
            error + QByteArray(", method: ") + opts.customSetterName);
    }

    if (opts.returnSpy) {
        *spyReturn = spy;
    } else {
        spy->deleteLater();
        spy = nullptr;
    }
}

/*!
 * Returns the number of values in \a enumerator name. If you have an object
 * of type T, use the second overload.
 */
template <typename T>
uint enumSize(const QByteArray &enumerator)
{
    const auto smo = T::staticMetaObject;
    const int indexOfPage = smo.indexOfEnumerator(enumerator.constData());
    const QMetaEnum metaEnum = smo.enumerator(indexOfPage);
    return uint(metaEnum.keyCount());
}

/*!
 * Returns the number of values in \a enumerator name. If you don't have an
 * object created, use the first overload.
 */
int enumSize(const QByteArray &enumerator, QObject *object)
{
    const auto smo = object->metaObject();
    const int indexOfPage = smo->indexOfEnumerator(enumerator.constData());
    const QMetaEnum metaEnum = smo->enumerator(indexOfPage);
    return metaEnum.keyCount();
}

/*!
 * Returns value represented by enum's index.
 *
 * For example:
 \code
 enum Foo {
   ValueA = 1,
   ValueB = 4
 }
 \endcode
 * In this case, enumValue() for \a index 0 (zero) is 1 (one). And for \a index
 * 1, the value is 4. Therefore, use this method to prevent errors when
 * iterating over enum values.
 */
int enumValue(const int index, const QByteArray &enumerator, QObject *object)
{
    const auto smo = object->metaObject();
    const int indexOfPage = smo->indexOfEnumerator(enumerator.constData());
    const QMetaEnum metaEnum = smo->enumerator(indexOfPage);
    return metaEnum.value(index);
}

/*!
 * Returns name of the enumeration value under \a index.
 *
 * \warning This method expects enum \a index, not enumValue().
 *
 * Example:
 \code
 enum Sth {
   Value = 8
 }

 enumKeyName() for \a index 0 will return "Value".
 \endcode
 */
QByteArray enumKeyName(const int index, const QByteArray &enumerator, QObject *object)
{
    const auto smo = object->metaObject();
    const int indexOfPage = smo->indexOfEnumerator(enumerator.constData());
    const QMetaEnum metaEnum = smo->enumerator(indexOfPage);
    return metaEnum.key(index);
}
}
