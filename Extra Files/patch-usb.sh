#!/bin/bash

#  patch-usb.sh
#  Patched Sur
#
#  Created by Benjamin Sova on 11/1/20.
#  Inspired by micropatcher.sh by BarryKN
#
#  Credit to some of the great people that
#  are working to make macOS run smoothly
#  on unsupported Macs
#

## MARK: Fun stuff

error() {
    echo
    echo "$1" 1>&2
    exit 1
}

echo 'Welcome to Patched Sur! (v0.0.2a build 10)'
echo 'This script *should only* be used through'
echo 'the Patched Sur app unless being tested'
echo 'for patcher development'
echo

# MARK: Detect USB and Payloads

echo 'Detecting Installer USB at /Volumes/Install macOS Big Sur Beta...'

if [ ! -d '/Volumes/Install macOS Big Sur Beta/Install macOS Big Sur Beta.app' ]
then
    echo 'Installer USB was not detected.'
    echo 'Please be sure to not rename the USB before'
    echo 'running patch-usb.sh.'
    error 'Error 2x1: Installer Not Found'
fi

INSTALLER='/Volumes/Install macOS Big Sur Beta'

echo 'Installer USB Detected!'

echo

echo 'Detecting Micropatcher at ~/.patched-sur/big-sur-micropatcher...'

MICROPATCHER=~/.patched-sur/big-sur-micropatcher/payloads

if [ ! -d "$MICROPATCHER" ]
then
    echo 'Micropatcher could not be found.'
    echo 'Please be sure that the micropatcher is in the'
    echo 'directory it is supposed to be in and this script'
    echo 'is being run in Patched Sur after the micropatcher'
    echo 'has been downloaded.'
    error 'Error 2x1 Micropatcher Not Found'
fi

echo

# MARK: Patch Boot PLIST

echo 'Patching Boot PLIST...'

# Apparently running CP then CAT is better than MV
# But I guess there is some sort of permissions trick
# That makes this better.

if [ ! -e "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist.stock" ]
then
    cp "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist" "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist.stock" || error 'Error 2x2 Unable backup boot plist.'
fi

cat "$MICROPATCHER/com.apple.Boot.plist" > "$INSTALLER/Library/Preferences/SystemConfiguration/com.apple.Boot.plist" || error 'Error 2x2 Unable replace boot plist.'

echo 'Patched Boot PLIST'
echo

# MARK: Adding Kexts to Installer USB

echo 'Adding Backup Kexts...'

cp -rf "$MICROPATCHER/kexts" "$INSTALLER" || error 'Error 2x2 Unable to add backup kexts to installer.'

echo 'Added Backup Kexts Successfully.'
echo

# MARK: Add BarryKN Hax Tool

echo 'Adding BarryKN Hax...'

cp -f "$MICROPATCHER/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib" "$INSTALLER" || error 'Error 2x2 Unable to add BarryKN hax to the USB.'
cp -f "$MICROPATCHER/ASentientBot-Hax/BarryKN-fork/HaxDoNotSealNoAPFSROMCheck.dylib" "$INSTALLER" || error 'Error 2x2 Unable to add BarryKN hax to the USB.'
cp -f "$MICROPATCHER/ASentientBot-Hax/BarryKN-fork/HaxSeal.dylib" "$INSTALLER" || error 'Error 2x2 Unable to add BarryKN hax to the USB.'
cp -f "$MICROPATCHER/ASentientBot-Hax/BarryKN-fork/HaxSealNoAPFSROMCheck.dylib" "$INSTALLER" || error 'Error 2x2 Unable to add BarryKN hax to the USB.'
cp -f "$MICROPATCHER/insert-hax.sh" "$INSTALLER" || error 'Error 2x2 Unable to add BarryKN hax scripts to the USB.'

echo 'Added BarryKN Hax.'
echo

# MARK: Add Backup Scripts

echo 'Adding Backup Scripts...'
echo 'Adding patch-kexts.sh...'
cp -f "$MICROPATCHER/patch-kexts.sh" "$INSTALLER" || error 'Error 2x2 Unable to add (un)patch.sh'
echo 'Adding extra commands...'
cp -rf ~/.patched-sur/big-sur-micropatcher/payloads/bin "$INSTALLER" || error 'Error 2x2 Unable to add extra commands.'
echo 'Added Backup Scripts...'
echo

# MARK: Setup Trampoline App

echo 'Setting up trampoline app...'
APPPATH="$INSTALLER/Install macOS Big Sur Beta.app"
TEMPAPP="$INSTALLER/tmp.app"
mv -f "$APPPATH" "$TEMPAPP"
cp -r "$MICROPATCHER/trampoline.app" "$APPPATH"
mv -f "$TEMPAPP" "$APPPATH/Contents/MacOS/InstallAssistant.app"
cp "$APPPATH/Contents/MacOS/InstallAssistant" "$APPPATH/Contents/MacOS/InstallAssistant_plain"
cp "$APPPATH/Contents/MacOS/InstallAssistant" "$APPPATH/Contents/MacOS/InstallAssistant_springboard"
pushd "$APPPATH/Contents" > /dev/null
for item in `cd MacOS/InstallAssistant.app/Contents;ls -1 | fgrep -v MacOS`
do
    ln -s MacOS/InstallAssistant.app/Contents/$item .
done
popd > /dev/null
touch "$APPPATH"
echo 'Setup trampoline app.'
echo

# MARK: Confirm Permissions

echo 'Confirming script permissions...'

chmod -R u+x "$INSTALLER"/*.sh "$INSTALLER"/Hax*.dylib "$INSTALLER"/bin

echo 'Confirmed permissions...'

echo

# MARK: Sync and Finish

echo 'Finishing drive processes...'
sync

echo

echo 'Finished Patching USB!'
