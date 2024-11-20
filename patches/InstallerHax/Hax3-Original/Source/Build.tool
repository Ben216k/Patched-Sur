set -e

cd "$(dirname "$0")"

libName=HaxLib
wrapperName=HaxWrapper
name=Hax3

clang -dynamiclib -fmodules -mmacosx-version-min=10.9 $libName.m -o $libName.dylib
codesign -f -s - $libName.dylib

osacompile -x -o $name.app $wrapperName.applescript
mv $libName.dylib $name.app/Contents/Resources/
rm $name.app/Contents/Resources/applet.icns