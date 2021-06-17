//
//  HandleVolumesActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import Foundation

func detectVolumes(onVol: (String) -> ()) -> (compat: [String], incompat: [(String, String)]) {
    var volumeList = ([], []) as (compat: [String], incompat: [(String, String)])
    
    print("Fetching mounted volumes")
    
    let possibleVolumes = (try? call("ls -1 /Volumes"))!.split(separator: "\n")
    print("Found: \(possibleVolumes.debugDescription)")
    
    possibleVolumes.forEach { volume in
        
        onVol(String(volume))
        
        print("Inspecting \(volume)")
        
        print("Fetching diskutil information")
        guard let diskInfo = try? call("diskutil list /Volumes/'\(volume)'") else {
            print("Unable to fetch disk information.")
            volumeList.incompat.append((String(volume), "Cannot find disk info, this might be a patcher bug."))
            return
        }
        
        let diskInfoLines = diskInfo.split(separator: "\n")
        
        // MARK: Synthesized Check
        print("Checking if the volume is synthesized")
        guard (try? call("echo '\(diskInfoLines[0])' | grep 'synthesized'")) == nil else {
            print("Volume is synthesized, this is incompatible")
            volumeList.incompat.append((String(volume), "Synthesized (APFS) volume, use MacOS Extended (Journaled)"))
            return
        }
        
        // MARK: Internal Drive Check
        print("Checking if the drive is internal")
        guard (try? call("echo '\(diskInfoLines[0])' | grep 'internal, physical'")) == nil else {
            print("Volume is an internal drive, this is incompatible")
            volumeList.incompat.append((String(volume), "Internal drive, use an external USB instead."))
            return
        }
        
        // MARK: Disk Image Check
        print("Checking if the drive is a disk image")
        guard (try? call("echo '\(diskInfoLines[0])' | grep 'disk image'")) == nil else {
            print("Volume is a disk image, this is incompatible")
            volumeList.incompat.append((String(volume), "Disk Images can't be booted, use an external USB."))
            return
        }
        
        // MARK: Has EFI Check
        print("Checking if the drive has an EFI partition")
        var efiCheckStuff = diskInfoLines[2]
        efiCheckStuff.removeFirst(11)
        efiCheckStuff = Substring(efiCheckStuff.replacingOccurrences(of: "*", with: ""))
        efiCheckStuff = efiCheckStuff.prefix("GUID_partition_scheme".count)
        print([efiCheckStuff])
        guard efiCheckStuff == "GUID_partition_scheme" else {
            print("Volume does not have an EFI partition, this is incompatible")
            volumeList.incompat.append((String(volume), "Not formatted with a GUID Partition Map"))
            return
        }
        
        print("Volume \(volume) passed all checks!")
        volumeList.compat.append(String(volume))
        
    }
    
    print("Found compatible volumes.")
    
    return volumeList
}
