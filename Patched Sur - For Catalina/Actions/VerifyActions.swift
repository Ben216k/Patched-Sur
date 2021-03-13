//
//  VerifyActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/12/21.
//

import Foundation

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
    barProgress(0.6)
    do {
        _ = try? shellOut(to: "rm -rf ~/.patched-sur/DetectProblems.sh")
        try shellOut(to: "curl -o DetectProblems.sh https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/DetectProblems.sh", at: "~/.patched-sur")
        try shellOut(to: "chmod u+x ~/.patched-sur/DetectProblems.sh")
    } catch {
        progress2 = VerifyProgress.errored
        errorX = "Failed to download possible problems.\n\(error.localizedDescription)"
        return
    }
    barProgress(0.9)
    if info != nil {
        do {
            known = try String(contentsOf: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/KnownContributors").split(separator: "\n")
        } catch {
            known = ["BenSova"]
            print("Failed to find known contributors, skipping this step.")
        }
    }
    barProgress(1)
    progress2 = .verifying
}

func verifyCompat(problems: inout [ProblemInfo], progress2: inout VerifyProgress, errorX: inout String, info: CompatInfo?) {
    do {
        let problemsToBe = try shellOut(to: "~/.patched-sur/DetectProblems.sh")
        problemsToBe.split(separator: "\n").forEach { problem in
            let details = problem.split(separator: ";")
            guard details.count == 3 else {
                if problem != "\n" {
                    print("Invalid check! Please report this to @BenSova as soon as possible!")
                    print("Include this in your message:")
                    print(problem)
                }
                return
            }
            let detectedProblem = ProblemInfo(title: String(details[1]), problemInfoDescription: String(details[2]), type: String(details[0]))
            problems.append(detectedProblem)
        }
        if problems.count > 0 {
            progress2 = .issues
        } else {
            progress2 = info != nil ? .clean : .noCompat
        }
    } catch {
        progress2 = .errored
        errorX = error.localizedDescription
    }
}
