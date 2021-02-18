set -e

cd "$(dirname "$0")"

name=Hax5

clang -dynamiclib -fmodules -mmacosx-version-min=10.9 -I ../../Code $name.m -o $name.dylib
codesign -f -s - $name.dylib

launchctl setenv DYLD_INSERT_LIBRARIES "$PWD/$name.dylib"

("/Applications/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"; launchctl unsetenv DYLD_INSERT_LIBRARIES; killall log) &

log stream -predicate '(message CONTAINS "Hax")'
