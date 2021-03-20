//
//  VerifyActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/12/21.
//

import VeliaUI

// MARK: Download Compatibility Info

func downloadCompat(info: inout CompatInfo?, known: inout [Substring], barProgress: (CGFloat) -> (), progress2: inout VerifyProgress, errorX: inout String) {
    _ = try? shellOut(to: "mkdir ~/.patched-sur")
    var macModel = ""
    do {
        macModel = try shellOut(to: "sysctl -n hw.model")
    } catch {
        progress2 = VerifyProgress.errored
        errorX = "Failed to detect Mac Model\n\(error.localizedDescription)"
        return
    }
    barProgress(0.1)
    print("Detected model:" + macModel)
    print("Downloading model details from: https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/Compatibility/\(macModel.replacingOccurrences(of: ",", with: "%2C")).json")
    do {
        info = try CompatInfo(fromURL: URL(string: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/Compatibility/\(macModel.replacingOccurrences(of: ",", with: "%2C")).json")!)
    } catch {
        print("Failed to fetch Mac Model compatibility report... Assuming it doesn't exist!")
    }
    barProgress(0.45)
    if info != nil {
        do {
            known = try String(contentsOf: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/KnownContributors").split(separator: "\n")
        } catch {
            known = ["BenSova"]
            print("Failed to find known contributors, skipping this step.")
        }
    }
    barProgress(0.5)
    progress2 = .verifying
}

// MARK: Verify Compatibility

func verifyCompat(barProgress: (CGFloat) -> (), problems: (ProblemInfo) -> (), progress2: inout VerifyProgress, errorX: inout String, info: CompatInfo?) {
    
    var hasProblem = false
    
    // MARK: BigMac Check
    
    print("Checking if this is a Mac Pro...")
    
    if let macModel = try? call("sysctl -n hw.model"), macModel.contains("MacPro") {
        problems(ProblemInfo(title: "There's a Better Patcher for Mac Pros", description: "While Patched Sur is a great for a lot of Macs, Mac Pros really shouldn't be used with this patcher. They don't have the proper patches, and there's another easy-to-use patcher designed specifically for Mac Pros. It's StarPlayrX's BigMac Patcher, and it'll give you an amazing experience for your Mac.", severity: .severe))
        hasProblem = true
    }
    
    barProgress(0.75)
    
    // MARK: FileVault Check
    
    print("Checking if FileVault is on...")
    
    if let fileVault = try? call("fdesetup status"), fileVault.contains("FileVault is On.") {
        if (try? call("sw_vers -productVersion | grep 10")) != nil {
            problems(ProblemInfo(title: "FileVault is On.", description: "Your Mac has FileVault enabled. While this is a good encryption tool, it breaks on Big Sur with unsupported Macs. You'll be completely unable to boot into recovery mode, and at times you may be unable to unlock your disk. You must disable this before running the patcher. You can do that by going into System Preferences, clicking Security & Privacy, go to FileVault, and click the lock icon and disable it.", severity: .fatal))
            hasProblem = true
        }
    }
    
    barProgress(0.98)
    
    // MARK: Metal Check
    
    print("Checking for Metal...")
    
    if let metalStatus = try? call("system_profiler SPDisplaysDataType | grep Metal"), !metalStatus.contains(": Supported") {
        problems(ProblemInfo(title: "No Graphics Acceleration", description: "Your Mac doesn't support Metal graphics acceleration, so Big Sur will run EXTREMELY SLOW. Do not expect it to be fast and do not expect it to run well. You cannot fix this and a patch is in progress to fix this, but it's current state is extremely unstable. If you would like to continue, you may, but don't expect a magical complete Big Sur experience.", severity: .severe))
        hasProblem = true
    }
    
    barProgress(1)
    
    if hasProblem {
        progress2 = .issues
    } else {
        progress2 = info != nil ? .clean : .noCompat
    }
    
}

// MARK: ProblemInfo

struct ProblemInfo {
    let title, description: String
    let severity: ProblemSeverity
}

enum ProblemSeverity {
    case warning
    case severe
    case fatal
}
