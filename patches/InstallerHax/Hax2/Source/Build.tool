set -e

cd "$(dirname "$0")"

libName=Hax2Lib
wrapperName=Hax2Wrapper
name=Hax2

clang -dynamiclib -fmodules $libName.m -o $libName.dylib
codesign -f -s - $libName.dylib

osacompile -x -o $name.app $wrapperName.applescript
mv $libName.dylib $name.app/Contents/Resources/
rm $name.app/Contents/Resources/applet.icns