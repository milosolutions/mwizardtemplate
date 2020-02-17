# Intro

As of Qt 5.14.1, `macdeployqt` tool is not good enough to properly codesign
appliactions for use in newest macOS systems. This is because stock
`macdeployqt` does not enable [hardened runtime](https://developer.apple.com/documentation/security/hardened_runtime) - and if it is already present, it is
being **removed**.

To fix this, we have prepared a simple patch for `macdeployqt` which enables
`--strict` and `-o runtime` flags on **all** binaries processed by the tool.

## Warning

This custom `macdeployqt` has to be compiled separately for **each Qt version**.

If you use deployment tool compiled with Qt 5.12.7 to deploy an app compiled
with Qt 5.14.1, for example, it will work. You will get a DMG or APP package. It
will go through notarization without a problem. **But the app will not run!**
That's because deployment tool will put 5.12.7 libraries into package together
with app compiled with 5.14.1 and they may not be compatible.

## Prepare

Take copy `macdeployqt` from your Qt source code:

    cp -r $QT_PATH/qttools/macdeployqt $dest/macdeployqt
    cd $dest/macdeployqt

Apply the patch accompanying this document:

    patch -p0 -i macdeployqt-hardened.patch

Compile your new tool:

    # Remember to use qmake from the same Qt version!
    qmake -v
    cd macdeployqt
    qmake
    make
    mv macdeployqt.app ../macdeployqt-hardened.app

The new deployment tool is in:

    $dest/macdeployqt/macdeployqt-hardened.app/Contents/MacOS/macdeployqt

## Use

Now you can use the new, hardened `macdeployqt` the same way you use the regular
version. For example:

    $dest/macdeployqt/macdeployqt-hardened.app/Contents/MacOS/macdeployqt \\
        application.app -verbose=2 \\
        -codesign="$CODESIGN_STRING" \\
        -dmg

You can then use the notarization script included together with this readme:

    python3 notarize-macos.py "team@name" "app-password" "com.application" \\
        application.dmg

For more information about notarization, see [Apple docs](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution#3087727).
