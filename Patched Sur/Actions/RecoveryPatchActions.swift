//
//  RecoveryPatchActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/18/21.
//

import Foundation

func downloadRecovery(errorX: (String) -> (), done: () -> ()) {
    if !AppInfo.nothing {
        do {
            print("Cleaning up before download")
            _ = try? call("rm -rf ~/.patched-sur/CatalinaRecovery.zip")
            _ = try? call("rm -rf ~/.patched-sur/CatalinaRecovery")
            _ = try? call("rm -rf ~/.patched-sur/__MACOSX")
            print("Downloading Recovery")
            try call("curl -Lo ~/.patched-sur/CatalinaRecovery.zip https://ia601405.us.archive.org/10/items/catalina-7-recovery/CatalinaRecovery.zip --speed-limit 0 --speed-time 10")
            print("Extracting Recovery")
            try call("unzip ~/.patched-sur/CatalinaRecovery.zip -d ~/.patched-sur")
            print("Cleaning up post-download")
            _ = try? call("rm -rf ~/.patched-sur/CatalinaRecovery.zip")
            _ = try? call("rm -rf ~/.patched-sur/__MACOSX")
            done()
        } catch {
            errorX(error.localizedDescription)
        }
    } else {
        print("HAHA NO DOWNLOAD")
        sleep(5)
    }
}

func installRecovery(password: String, statusText: (String) -> (), errorX: (String) -> (), done: () -> ()) {
    if !AppInfo.nothing {
        do {
            print("Extracting Patches")
            statusText("Extracting Patches")
            _ = try? call("mkdir /usr/local/lib", p: password)
            _ = try? call("rm -rf ~/.patched-sur/__MACOSX", p: password)
            _ = try? call("rm -rf /usr/local/lib/__MACOSX", p: password)
            _ = try? call("rm -rf Patched-Sur-Patches*", p: password, at: "/usr/local/lib")
            if let sharedSupport = Bundle.main.sharedSupportPath, (try? call("[[ -e \(sharedSupport)/Patched-Sur-Patches.zip ]]")) != nil {
                try call("unzip \(sharedSupport)/Patched-Sur-Patches.zip -d /usr/local/lib", p: password, at: "/usr/local/lib")
            } else {
                try call("unzip ~/.patched-sur/Patched-Sur-Patches.zip -d /usr/local/lib", p: password, at: "/usr/local/lib")
            }
            try call("mv Patched-Sur-Patches-* Patched-Sur-Patches", p: password, at: "/usr/local/lib")
            _ = try? call("rm -rf ~/.patched-sur/__MACOSX", p: password)
            _ = try? call("rm -rf /usr/local/lib/__MACOSX", p: password)
            _ = try? call("echo '\(AppInfo.patchesV.version)' > /usr/local/lib/Patched-Sur-Patches/pspVersion", p: password)
            print("Fetching Recovery Info")
            statusText("Fetching Recovery Info")
            let recoveryAPFSID = try call("diskutil info \"$(mount | head -n 1 | cut -d \" \" -f 1 | cut -c 6-)\" | grep \"APFS Volume Group\" | cut -c 31-")
    //        let recoveryDiskID = try call("diskutil list | grep Recovery | cut -c 71-")
            print("Mounting Recovery")
            statusText("Mounting Recovery")
            try call("diskutil mount \"$(diskutil list / | grep Recovery | sed 's/^.*disk/disk/' | head -n 1)\"", p: password)
            try call("mount -uw /Volumes/Recovery", p: password)
            print("Backing Up BaseSystem")
            statusText("Backing Up BaseSystem")
            _ = try? call("rm -rf ~/.patched-sur/BaseSystemBackup.dmg")
            _ = try? call("rm -rf ~/.patched-sur/BaseSystemBackup.chunklist")
            try call("cp /Volumes/Recovery/\(recoveryAPFSID)/BaseSystem.dmg ~/.patched-sur/BaseSystemBackup.dmg")
            try call("cp /Volumes/Recovery/\(recoveryAPFSID)/BaseSystem.chunklist ~/.patched-sur/BaseSystemBackup.chunklist")
            print("Purging Old Recovery")
            statusText("Purging Old Recovery")
            try call("rm -rf /Volumes/Recovery/\(recoveryAPFSID)", p: password)
            print("Copying New Recovery")
            statusText("Copying New Recovery")
            try call("cp -a ~/.patched-sur/CatalinaRecovery /Volumes/Recovery/\(recoveryAPFSID)", p: password)
            print("Copying BaseSystem")
            statusText("Copying BaseSystem")
            _ = try? call("rm -rf /Volumes/Recovery/\(recoveryAPFSID)/BaseSystem.dmg", p: password)
            _ = try? call("rm -rf /Volumes/Recovery/\(recoveryAPFSID)/BaseSystem.chunklist", p: password)
            try call("cp ~/.patched-sur/BaseSystemBackup.dmg /Volumes/Recovery/\(recoveryAPFSID)/BaseSystem.dmg", p: password)
            try call("cp ~/.patched-sur/BaseSystemBackup.chunklist /Volumes/Recovery/\(recoveryAPFSID)/BaseSystem.chunklist", p: password)
            print("Done patching recovery!")
            done()
        } catch {
            errorX(error.localizedDescription)
        }
    } else {
        print("HAHAHAHAH NOOOOOO")
        sleep(5)
    }
}
