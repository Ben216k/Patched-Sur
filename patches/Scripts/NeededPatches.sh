#!/bin/bash

#
#  PatchSystem.sh
#  Patched Sur
#
#  Created by Ben Sova on 5/15/21
#

exitIfUnknown() {
    if [[ "$1" == "--rerun" ]]; then
        echo "Failed to find Needed Patches, this Mac probably doesn't support the patcher (or just doesn't need it)." 1>&2
        exit 1
    fi
}

# Check what patches to use.
if [ -z "$PATCHMODE" ]
then
    MODEL=`sysctl -n hw.model`
    case $MODEL in
    # Macs that support this patcher.
    MacBook[4-7],?|Macmini[34],1|MacBookAir[23],?|MacBookPro[457],?|MacPro3,1|iMac[0-9],?|iMac10,?)
        echo "UNKNOWN"
        exitIfUnknown
        ;;
    Macmini5,?|MacBookAir4,?|MacBookPro8,?)
        echo "UNKNOWN"
        exitIfUnknown
        ;;
    iMac11,?)
        echo "UNKNOWN"
        exitIfUnknown
        ;;
    iMac12,?)
        echo "UNKNOWN"
        exitIfUnknown
        ;;
    Macmini6,?|MacBookAir5,?|MacBookPro9,?|MacBookPro10,?|iMac13,?|MacPro[45],1|iMac14,[123])
        echo "(2012):BOOTPLIST"
        BOOTPLIST="--bootPlist"
        ;;
    # Everything else
    *)
        echo "UNKNOWN"
        exitIfUnknown
        ;;
    esac
fi

if [ -z "`ioreg -l | fgrep 802.11 | fgrep ac`" ]; then
    echo "(MORE):WIFI-NEW"
    WIFI="--wifi=nativePlus"
fi

if [[ "$1" == "--rerun" ]]; then
    echo "Running PatchSystem.sh..."
    "$2/PatchSystem.sh" $WIFI $BOOTPLIST "$3"
    exit $?
fi
