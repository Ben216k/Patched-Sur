//
//  ExpressDetection.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import Foundation

struct ProblemInfo {
    let title, description: String
}

// MARK: - Check Compatability

func verifyCompat(barProgress: (CGFloat) -> (), problems: (ProblemInfo) -> ()) {
    
    var hasProblem = false
    
    // MARK: BigMac Check
    
    print("Checking if this is a Mac Pro...")
    
    if let macModel = try? call("sysctl -n hw.model"), macModel.contains("MacPro") {
        problems(ProblemInfo(title: .init("PROB-PRO-TITLE"), description: .init("PROB-PRO-DESCRIPTION")))
        hasProblem = true
    }
    
    barProgress(0.15)
    
    // MARK: FileVault Check
    
    print("Checking if FileVault is on...")
    
    if let fileVault = try? call("fdesetup status"), fileVault.contains("FileVault is On.") {
        if (try? call("sw_vers -productVersion | grep 11")) != nil {
            problems(ProblemInfo(title: .init("PROB-FILE-TITLE"), description: .init("PROB-FILE-DESCRIPTION")))
            hasProblem = true
        }
    }
    
    barProgress(0.3)
    
    // MARK: Metal Check
    
    print("Checking for Metal...")
    
    if let metalStatus = try? call("system_profiler SPDisplaysDataType | grep Metal"), !metalStatus.contains(": Supported") { //, !metalStatus.contains(": Metal 3")  {
        problems(ProblemInfo(title: .init("PROB-GX-TITLE"), description: .init("PROB-GX-DESCRIPTION")))
        hasProblem = true
    }
    
    barProgress(0.45)
    
}
