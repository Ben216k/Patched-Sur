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

echo 'Welcome to Patched Sur! (v0.0.4)'
echo 'This script *should only* be used through'
echo 'the Patched Sur app unless being tested'
echo 'for patcher development'
echo

# MARK: Detect USB and Payloads

echo 'Detecting Installer USB at /Volumes/Install macOS Big Sur [Beta]...'

if [ -d '/Volumes/Install macOS Big Sur Beta/Install macOS Big Sur Beta.app' ]
then
    INSTALLER='/Volumes/Install macOS Big Sur Beta'
    APPPATH="$INSTALLER/Install macOS Big Sur Beta.app"
elif [ -d '/Volumes/Install macOS Big Sur/Install macOS Big Sur.app' ]
then
    INSTALLER='/Volumes/Install macOS Big Sur'
    APPPATH="$INSTALLER/Install macOS Big Sur.app"
else
    echo 'Installer USB was not detected.'
    echo 'Please be sure to not rename the USB before'
    echo 'running patch-usb.sh.'
    error 'Error 2x1: Installer Not Found'
fi

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

# MARK: The Extra Things

echo 'Adding Post Install app...'

cp -rf /Volumes/Patched-Sur/.fullApp.app "$INSTALLER"/Patched-Sur.app || error 'Error 2x2: Unable to add post install app.'

echo 'Added Post Install app'

echo

echo 'Theming the installer icon...'

cp -rf /Volumes/Patched-Sur/.InstallIcon.icns "$INSTALLER"/.VolumeIcon.icns

echo 'Themed (or at least tried to) the installer icon'

echo

# MARK: Sync and Finish

echo 'Finishing drive processes...'

sync

echo

echo 'Finished Patching USB!'
echo 'Now installing SetVars tool...'

# MARK: Install SetVars

# This code is from the micropatcher. I only have it here because I want to make it easier for some users to visualize what drive there Mac is booting to.

checkDirAccess() {
    # List the two directories, but direct both stdout and stderr to
    # /dev/null. We are only interested in the return code.
    ls "$VOLUME" . &> /dev/null
}

# Make sure there isn't already an "EFI" volume mounted.
if [ -d "/Volumes/EFI" ]
then
    echo 'An "EFI" volume is already mounted. Please unmount it then try again.'
    echo "If you don't know what this means, then restart your Mac and try again."
    echo
    echo "install-setvars cannot continue."
    exit 1
fi

# For this script, root permissions are vital.
[ $UID = 0 ] || exec sudo "$0" "$@"

# Allow the user to drag-and-drop the USB stick in Terminal, to specify the
# path to the USB stick in question. (Otherwise it will try hardcoded paths
# for a presumed Big Sur Golden Master/public release, beta 2-or-later,
# and beta 1, in that order.)
if [ -z "$1" ]
then
    for x in "Install macOS Big Sur" "Install macOS Big Sur Beta" "Install macOS Beta"
    do
        if [ -d "/Volumes/$x/$x.app" ]
        then
            VOLUME="/Volumes/$x"
            APPPATH="$VOLUME/$x.app"
            break
        fi
    done

    if [ ! -d "$APPPATH" ]
    then
        echo "Failed to locate Big Sur recovery USB stick."
        echo "Remember to create it using createinstallmedia, and do not rename it."
        echo "If all else fails, try specifying the path to the USB stick"
        echo "as a command line parameter to this script."
        echo
        echo "install-setvars cannot continue and will now exit."
        exit 1
    fi
else
    VOLUME="$1"
    # The use of `echo` here is to force globbing.
    APPPATH=`echo -n "$VOLUME"/Install\ macOS*.app`
    if [ ! -d "$APPPATH" ]
    then
        echo "Failed to locate Big Sur recovery USB stick for patching."
        echo "Make sure you specified the correct volume. You may also try"
        echo "not specifying a volume and allowing the patcher to find"
        echo "the volume itself."
        echo
        echo "install-setvars cannot continue and will now exit."
        exit 1
    fi
fi

cd ~/.patched-sur/big-sur-micropatcher

# Check again in case we changed directory after the first check
if [ ! -d payloads ]
then
    echo '"payloads" folder was not found.'
    echo
    echo "install-setvars cannot continue and will now exit."
    exit 1
fi

# Check to make sure we can access both our own directory and the root
# directory of the USB stick. Terminal's TCC permissions in Catalina can
# prevent access to either of those two directories. However, only do this
# check on Catalina or higher. (I can add an "else" block later to handle
# Mojave and earlier, but Catalina is responsible for every single bug
# report I've received due to this script lacking necessary read permissions.)
if [ `uname -r | sed -e 's@\..*@@'` -ge 19 ]
then
    echo 'Checking read access to necessary directories...'
    if ! checkDirAccess
    then
        echo 'Access check failed.'
        tccutil reset All com.apple.Terminal
        echo 'Retrying access check...'
        if ! checkDirAccess
        then
            echo
            echo 'Access check failed again. Giving up.'
            echo 'Next time, please give Terminal permission to access removable drives,'
            echo 'as well as the location where this patcher is stored (for example, Downloads).'
            exit 1
        else
            echo 'Access check succeeded on second attempt.'
            echo
        fi
    else
        echo 'Access check succeeded.'
        echo
    fi
fi

MOUNTEDPARTITION=`mount | fgrep "$VOLUME" | awk '{print $1}'`
if [ -z "$MOUNTEDPARTITION" ]
then
    echo Failed to find the partition that
    echo "$VOLUME"
    echo is mounted from. install-setvars cannot proceed.
    exit 1
fi

DEVICE=`echo -n $MOUNTEDPARTITION | sed -e 's/s[0-9]*$//'`
PARTITION=`echo -n $MOUNTEDPARTITION | sed -e 's/^.*disk[0-9]*s//'`
echo "$VOLUME found on device $MOUNTEDPARTITION"

if [ "x$PARTITION" = "x1" ]
then
    echo "The volume $VOLUME"
    echo "appears to be on partition 1 of the USB stick, therefore the stick is"
    echo "incorrectly partitioned (possibly MBR instead of GPT?)."
    echo
    echo 'Please use Disk Utility to erase the USB stick as "Mac OS Extended'
    echo '(Journaled)" format on "GUID Partition Map" scheme and start over with'
    echo '"createinstallmedia". Or for other methods, please refer to the micropatcher'
    echo "README for more information."
    echo
    echo "install-setvars cannot continue."
    exit 1
fi

diskutil mount ${DEVICE}s1
if [ ! -d "/Volumes/EFI" ]
then
    echo "Partition 1 of the USB stick does not appear to be an EFI partition, or"
    echo "mounting of the partition somehow failed."
    echo
    echo 'Please use Disk Utility to erase the USB stick as "Mac OS Extended'
    echo '(Journaled)" format on "GUID Partition Map" scheme and start over with'
    echo '"createinstallmedia". Or for other methods, please refer to the micropatcher'
    echo "README for more information."
    echo
    echo "install-setvars cannot continue."
    exit 1
fi

# Before proceeding with the actual installation, see if we were provided
# a command line option for SIP/ARV, and if not, make a decision based
# on what Mac model this is.
if [ -z "$SIPARV" ]
then
    MACMODEL=`sysctl -n hw.model`
    echo "Detected Mac model is:" $MACMODEL
    case $MACMODEL in
    "iMac14,1" | "iMac14,2" | "iMac14,3")
        echo "Late 2013 iMac detected, so enabling SIP/ARV."
        echo "(Use -d option to disable SIP/ARV if necessary.)"
        SIPARV="YES"
        ;;
    *)
        echo "This Mac is not a Late 2013 iMac, so disabling SIP/ARV."
        echo "(Use -e option to enable SIP/ARV if necessary.)"
        SIPARV="NO"
        ;;
    esac

    echo
fi

# Now do the actual installation
echo "Installing setvars EFI utility."
rm -rf /Volumes/EFI/EFI
if [ "x$VERBOSEBOOT" = "xYES" ]
then
    if [ "x$SIPARV" = "xYES" ]
    then
        echo 'Verbose boot enabled, SIP/ARV enabled'
        cp -r setvars/EFI-enablesiparv-vb /Volumes/EFI/EFI
    else
        echo 'Verbose boot enabled, SIP/ARV disabled'
        cp -r setvars/EFI-verboseboot /Volumes/EFI/EFI
    fi
elif [ "x$SIPARV" = "xYES" ]
then
    echo 'Verbose boot disabled, SIP/ARV enabled'
    cp -r setvars/EFI-enablesiparv /Volumes/EFI/EFI
else
    echo 'Verbose boot disabled, SIP/ARV disabled'
    cp -r setvars/EFI /Volumes/EFI/EFI
fi

echo 'Adding icons...'

cp -rf /Volumes/Patched-Sur/.EFIIcon.icns /Volumes/EFI/.VolumeIcon.icns

echo "Unmounting EFI volume (if this fails, just eject in Finder afterward)."
umount /Volumes/EFI || diskutil unmount /Volumes/EFI

echo
echo 'install-setvars finished.'
