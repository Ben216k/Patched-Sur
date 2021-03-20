//
//  HandleVolumesActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import Foundation

func detectVolumes(onVol: (String) -> ()) -> [String] {
    var volumeList = [] as [String]
    
    print("Fetching mounted volumes")
    
    let possibleVolumes = (try? call("ls -1 /Volumes"))!.split(separator: "\n")
    print("Found: \(possibleVolumes.debugDescription)")
    
    possibleVolumes.forEach { volume in
        
        onVol(String(volume))
        
        print("Inspecting \(volume)")
        
        print("Fetching diskutil information")
        guard let diskInfo = try? call("diskutil list /Volumes/'\(volume)'") else {
            print("Unable to fetch disk information.")
            return
        }
        
        // MARK: Synthesized Check
        print("Checking if the volume is synthesized")
        guard !diskInfo.contains("(synthesized):") else {
            print("Volume is synthesized, this is incompatible")
            return
        }
        
        // MARK: Internal Drive Check
        print("Checking if the drive is internal")
        guard !diskInfo.contains("(internal, physical):") else {
            print("Volume is an internal drive, this is incompatible")
            return
        }
        
        // MARK: Disk Image Check
        print("Checking if the drive is a disk image")
        guard !diskInfo.contains("(disk image):") else {
            print("Volume is a disk image, this is incompatible")
            return
        }
        
        // MARK: Has EFI Check
        print("Checking if the drive has an EFI partition")
        guard !diskInfo.contains("1:                        EFI EFI") else {
            print("Volume does not have an EFI partition, this is incompatible")
            return
        }
        
        print("Volume \(volume) passed all checks!")
        volumeList.append(String(volume))
        
    }
    
    print("Found compatible volumes.")
    
    return volumeList
}
