#!/bin/bash

#  PatchUSB.sh
#  Patched Sur
#
#  Created by Ben Sova on 11/1/20.
#  Rewritten for Patched-Sur-Patches on 4/1/21.
#  Inspired by micropatcher.sh by BarryKN
#
#  Credit to some of the great people that
#  are working to make macOS run smoothly
#  on unsupported Macs
#

## MARK: Fun stuff

[ $UID = 0 ] || exec sudo "$0" "$@"

error() {
    echo
    echo "$1" 1>&2
    exit 1
}

echo "Welcome to PatchUSB.sh (for Patched Sur)!"
echo 'This script should really only be used'
echo 'through the Patched Sur app unless being'
echo 'tested for patcher development'
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

echo 'Detecting patches at /usr/local/lib/Patched-Sur-Patches...'

PATCHES='/usr/local/lib/Patched-Sur-Patches'

if [ ! -d "$PATCHES" ]
then
    echo 'Patched Sur Patches could not be found.'
    echo 'Please be sure that the Patched Sur Patches is in'
    echo 'the directory it is supposed to be in and this'
    echo 'script is being run in Patched Sur after the'
    echo 'patches have been copied.'
    error 'Error 2x1 Patched Sur Patches Not Found'
fi

echo "Detecting resource argument at $1..."

if [ ! -d "$1/Patched Sur - Recovery.app" ]
then
    echo 'The Resource argument, which provides'
    echo 'where the Patched Sur post-install and recovery'
    echo 'apps are, was either not given or is not valid.'
    error 'Resource argument invalid.'
fi

RESOURCEDIR="$1"

echo

# MARK: Patch Boot PLIST

echo 'Patching Boot PLIST...'

# Apparently running CP then CAT is better than MV
# but I guess there is some sort of permissions trick
# that makes this better.

if [ ! -e "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist.stock" ]
then
    cp "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist" "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist.stock" || error 'Error 2x2 Unable backup boot plist.'
fi

cat "$PATCHES/InstallerPatches/com.apple.Boot.plist" > "$INSTALLER/Library/Preferences/SystemConfiguration/com.apple.Boot.plist" || error 'Error 2x2 Unable replace boot plist.'

echo 'Patched Boot PLIST'
echo

# MARK: Adding Kexts to Installer USB

echo 'Adding Backup Kexts...'

cp -rf "$PATCHES/KextPatches" "$INSTALLER" || error 'Error 2x2 Unable to add patched kexts to installer.'
cp -rf "$PATCHES/SystemPatches" "$INSTALLER" || error 'Error 2x2 Unable to add system patches to installer.'

echo 'Added Backup Kexts Successfully.'
echo

# MARK: Add BarryKN Hax Tool

echo 'Adding BarryKN Hax...'

mkdir "$INSTALLER/InstallerHax" || error 'Error 2x2 Somehow unable to make BarryKN Hax folder.'
cp -rf "$PATCHES/InstallerHax/Hax3-BarryKN/HaxDoNotSeal.dylib" "$INSTALLER/InstallerHax/NoSeal.dylib" || error 'Error 2x2(1) Unable to add BarryKN Hax to the USB.'
cp -rf "$PATCHES/InstallerHax/Hax3-BarryKN/HaxSeal.dylib" "$INSTALLER/InstallerHax/YesSeal.dylib" || error 'Error 2x2(2) Unable to add BarryKN Hax to the USB.'
cp -rf "$PATCHES/InstallerHax/Hax3-BarryKN/HaxSealNoAPFSROMCheck.dylib" "$INSTALLER/InstallerHax/YesSealNoAPFS.dylib" || error 'Error 2x2(3) Unable to add BarryKN Hax to the USB.'
cp -rf "$PATCHES/InstallerHax/Hax3-BarryKN/HaxDoNotSealNoAPFSROMCheck.dylib" "$INSTALLER/InstallerHax/NoSealNoAPFS.dylib" || error 'Error 2x2(4) Unable to add BarryKN Hax to the USB.'

echo 'Added BarryKN Hax.'
echo

# MARK: Add Backup Scripts

#echo "PatchKexts.sh cannot be added yet."
echo 'Adding Backup Scripts...'
echo 'Adding PatchSystem.sh...'
cp -f "$PATCHES/Scripts/PatchKexts.sh" "$INSTALLER" || error 'Error 2x2 Unable to add PatchKexts.sh'
cp -f "$PATCHES/Scripts/PatchSystem.sh" "$INSTALLER" || error 'Error 2x2 Unable to add PatchSystem.sh'
cp -f "$PATCHES/Scripts/NeededPatches.sh" "$INSTALLER" || error 'Error 2x2 Unable to add NeededPatches.sh'
echo 'Adding extra commands...'
cp -a $PATCHES/ArchiveBin "$INSTALLER/ArchiveBin" || error 'Error 2x2 Unable to add extra commands.'
#echo 'Added extra commands...'
echo 'Added Backup Scripts...'
#echo

# MARK: Setup Trampoline App

echo 'Setting up trampoline app...'
TEMPAPP="$INSTALLER/tmp.app"
mv -f "$APPPATH" "$TEMPAPP"
cp -r "$PATCHES/InstallerPatches/trampoline.app" "$APPPATH"
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

chmod -R u+x "$INSTALLER"/*.sh "$INSTALLER"/InstallerHax/*.dylib "$INSTALLER"/ArchiveBin

echo 'Confirmed permissions...'

echo

# MARK: The Extra Things


echo 'Theming the installer icon...'

cp -rf $PATCHES/Images/InstallIcon.icns "$INSTALLER"/.VolumeIcon.icns

echo 'Themed (or at least tried to) the installer icon'

echo 'Replacing Boot.efi'

cp -rf "$PATCHES/InstallerPatches/boot.efi" "$INSTALLER/System/Library/CoreServices/boot.efi"

echo 'Replaced Boot.efi'

echo

# MARK: BaseSystem Patching

echo "Removing file that doesn't matter"
rm -rf "$INSTALLER/BaseSystem/BaseSystem.dmg.shadow" || echo "Failed to remove this file that doesn't matter"

echo 'Safety sleep'
sleep 30

echo "Removing file that doesn't matter"
rm -rf "$INSTALLER/BaseSystem/BaseSystem.dmg.shadow" || echo "Failed to remove this file that doesn't matter"

echo 'Mounting BaseSystem...'

function reHDI {
    echo "RM -RFing"
    rm -rf "/Volumes/Install macOS Big Sur/BaseSystem/BaseSystem.dmg.shadow" || echo "Failed to remove this file that doesn't matter"
    rm -rf "/Volumes/Install macOS Big Sur Beta/BaseSystem/BaseSystem.dmg.shadow" || echo "Failed to remove this file that doesn't matter"
    echo "Mounting BaseSystem, try 2..."
    hdiutil attach -owners on "$INSTALLER/BaseSystem/BaseSystem.dmg" -nobrowse -shadow || error 'Error 2x3: Unable to shadow mount BaseSystem.'
}

hdiutil attach -owners on "$INSTALLER/BaseSystem/BaseSystem.dmg" -nobrowse -shadow || reHDI

cd "/Volumes/macOS Base System/System/Installation/CDIS/Recovery Springboard.app/Contents/Resources"

echo 'Adding new Utilities.plist...'
cp -rf "$PATCHES/InstallerPatches/Utilities.plist" "Utilities.plist" || error 'Error 2x3: Unable to replace Utilities.plist.'

cd "/Volumes/macOS Base System/Applications"
echo "Removing old patcher app if it's there"
rm -rf "Patched Sur - Recovery.app"
echo 'Adding new patcher app...'
cp -a "$RESOURCEDIR/Patched Sur - Recovery.app" "Patched Sur - Recovery.app" || error 'Error 2x3: Unable to add patcher recovery app.'

cd "/Volumes/macOS Base System/usr/lib"
echo 'Unzipping Swift frameworks into library'
unzip "$PATCHES/InstallerPatches/swift.zip" -d . || error 'Error 2x3: Unable to add swift libraries.'

cd "$PATCHES"
echo "Detacting BaseSystem"
hdiutil detach "/Volumes/macOS Base System"
echo "Getting Installer Disk ID"
DISKID=$(df "$INSTALLER" | tail -1 | sed -e 's@ .*@@')
echo "Unmounting Installer"
diskutil unmount force "$DISKID"
echo "Remounting Installer"
diskutil mount "$DISKID"

echo "Applying Shadow"
hdiutil convert -format UDZO -o "$INSTALLER/BaseSystem/BaseSystem2.dmg" "$INSTALLER/BaseSystem/BaseSystem.dmg" -shadow
echo "Switching BaseSystems"
cd "$INSTALLER/BaseSystem"
mv BaseSystem.dmg BaseSystembackup.dmg
mv BaseSystem2.dmg BaseSystem.dmg

# MARK: Sync and Finish

echo 'Finishing drive processes...'

sync

echo

echo 'Finished Patching USB!'
echo 'Now installing SetVars tool...'

# MARK: - Install SetVars

# This code is from the micropatcher.

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

# Allow the user to drag-and-drop the USB stick in Terminal, to specify the
# path to the USB stick in question. (Otherwise it will try hardcoded paths
# for a presumed Big Sur Golden Master/public release, beta 2-or-later,
# and beta 1, in that order.)
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

cd $PATCHES

# Check again in case we changed directory after the first check
if [ ! -d EFISetvars ]
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

DEVICE=`echo -n $MOUNTEDPARTITION | sed -e 's/s[0-9]*$//' | head -n 1 | sed -e 's/s[0-9]*$//' | head -n 1 | sed -e 's+/dev/++g' | sed -e 's/disk.s2 //g'`
PARTITION=`echo -n $MOUNTEDPARTITION | sed -e 's/^.*disk[0-9]*s//'`
echo "$VOLUME found on device $MOUNTEDPARTITION"

if [ "x$PARTITION" = "x1" ]
then
    echo "The volume $VOLUME"
    echo "appears to be on partition 1 of the USB stick, therefore the stick is"
    echo "incorrectly partitioned (possibly MBR instead of GPT?)."
    echo
    echo 'Please use Disk Utility to erase the USB stick as "Mac OS Extended'
    echo '(Journaled)" format on "GUID Partition Map" scheme'
    echo
    echo "install-setvars cannot continue."
    exit 1
fi

echo "----"
echo "${DEVICE}"
echo "----"
echo "diskutil mount ${DEVICE}s1"
echo "----"
diskutil mount ${DEVICE}s1
if [ ! -d "/Volumes/EFI" ]
then
    echo "Partition 1 of the USB stick does not appear to be an EFI partition, or"
    echo "mounting of the partition somehow failed."
    echo
    echo 'Please use Disk Utility to erase the USB stick as "Mac OS Extended'
    echo '(Journaled)" format on "GUID Partition Map" scheme'
    echo
    echo "install-setvars cannot continue."
    exit 1
fi

# Now do the actual installation
echo "Installing setvars EFI utility."
rm -rf /Volumes/EFI/EFI
echo 'Verbose boot disabled, SIP/ARV disabled'
cp -r EFISetvars/EFI /Volumes/EFI/EFI

echo 'Adding icons...'
cp -rf $PATCHES/Images/EFIIcon.icns /Volumes/EFI/.VolumeIcon.icns

echo "Unmounting EFI volume (if this fails, just eject in Finder afterward)."
umount /Volumes/EFI || diskutil unmount /Volumes/EFI

echo
echo 'install-setvars finished.'
