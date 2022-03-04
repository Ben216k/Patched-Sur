//
//  PatchKextsActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/3/21.
//

import Foundation

// MARK: Detect Patches

func detectPatches(installerName: (String?) -> (), legacy: (Bool) -> (), oldKext: (Bool) -> ()) {
    // Detect Patched-Sur-Patches
    print("Checking for USB at \"/Volumes/Install macOS Big Sur Beta/KextPatches\"...")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur Beta/KextPatches' ]]")) != nil {
        print("Found PSPatches at Beta path")
        oldKext((try? call("[[ -e '/Volumes/Install macOS Big Sur Beta/PatchSystem.sh' ]]")) == nil)
        installerName("'/Volumes/Install macOS Big Sur Beta'")
        return
    }
    print("Checking for USB at \"/Volumes/Install macOS Big Sur/KextPatches\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur/KextPatches' ]]")) != nil {
        print("Found PSPatches at Regular path")
        oldKext((try? call("[[ -e '/Volumes/Install macOS Big Sur/PatchSystem.sh' ]]")) == nil)
        installerName("'/Volumes/Install macOS Big Sur'")
        return
    }
    print("Checking for kexts at \"/usr/local/lib/Patched-Sur-Patches/KextPatches")
    if (try? call("[[ -d /usr/local/lib/Patched-Sur-Patches/KextPatches ]]")) != nil {
        print("Found pre-downloaded kexts!")
        oldKext((try? call("[[ -e '/usr/local/lib/Patched-Sur-Patches/Scripts/PatchSystem.sh' ]]")) == nil)
        installerName("/usr/local/lib/Patched-Sur-Patches/Scripts")
        return
    }
    
    // Detect micropatcher (Legacy)
    print("Checking for micropatcher kexts at \"/Volumes/Install macOS Big Sur Beta/kexts\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur Beta/kexts' ]]")) != nil {
        print("Found micropatcher at legacy Beta path")
        print("It is! This will be used even though it is the last resort.")
        installerName("'/Volumes/Install macOS Big Sur Beta'")
        oldKext(true)
        legacy(true)
        return
    }
    print("Checking for micropatcher kexts at \"/Volumes/Install macOS Big Sur/kexts\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur/kexts' ]]")) != nil {
        print("Found micropatcher at legacy regular path")
        print("It is! This will be used even though it is the last resort.")
        installerName("'/Volumes/Install macOS Big Sur'")
        oldKext(true)
        legacy(true)
        return
    }
    print("Checking for micropatcher kexts at \"~/.patched-sur/big-sur-micropatcher/payloads/kexts\"")
    if (try? call("[[ -d ~/.patched-sur/big-sur-micropatcher/payloads/kexts ]]")) != nil {
        print("Found micropatcher at legacy pre-downloaded path")
        print("Confirming this is Ben's fork")
        if (try? call("cat ~/.patched-sur/big-sur-micropatcher/payloads/patch-kexts.sh | grep \".patched-sur/big-sur-micropatcher/payloads\"")) != nil {
            print("It is! This will be used even though it is the last resort.")
            installerName("~/.patched-sur/big-sur-micropatcher/payloads")
            oldKext(true)
            legacy(true)
            return
        }
    }
    installerName(nil)
}

func patchKexts(password: String, legacy: Bool, unpatch: Bool, location: String, errorX: (String?) -> ()) {
    if !AppInfo.nothing {
        print("Starting Patch Kexts")
        do {
            sleep(2)
            if legacy {
                print("Warning: Starting legacy patch kexts mode.")
                print("These patches haven't really been updated since a long time ago.")
                let output = try call("\(location)/patch-kexts.sh\(unpatch ? " -u" : "")", p: password)
                UserDefaults.standard.setValue("Warning: Legacy Patch Kexts Mode was used.\n" + output, forKey: "PatchKextsLastRun")
            } else {
                let output = try call("\(location)/PatchKexts.sh\(unpatch ? " -u" : "")", p: password)
                UserDefaults.standard.setValue(output, forKey: "PatchKextsLastRun")
            }
            errorX(nil)
        } catch {
            let log = (legacy ? "Warning: Legacy Patch-Kexts.sh Mode was used.\n" : "Warning: Legacy Patch Kexts Mode was used.") + error.localizedDescription
            UserDefaults.standard.setValue(log, forKey: "PatchKextsLastRun")
            errorX(log)
        }
    } else {
        print("YOU WANT ME TO PATCH THE KEXTS?! I'm sleeping for 5 seconds instead.")
        sleep(5)
        errorX(nil)
    }
}

func patchSystem(password: String, arguments: String, location: String, unpatch: Bool, errorX: (String?) -> ()) {
    if !AppInfo.nothing {
        print("Starting Patch System")
        do {
            let output = try call("\(location)/PatchSystem.sh\(unpatch ? " -u" : "")\(arguments)", p: password)
            print("Finished Patch System, saving output")
            UserDefaults.standard.setValue(output, forKey: "PatchKextsLastRun")
            errorX(nil)
        } catch {
            print("Finished Patch System, but it failed, saving output.")
            UserDefaults.standard.setValue(error.localizedDescription, forKey: "PatchKextsLastRun")
            errorX(error.localizedDescription)
        }
    } else {
        print("YOU WANT ME TO PATCH THE SYSTEM?! I'm sleeping for 5 seconds instead.")
        sleep(5)
        errorX(nil)
    }
}

func argumentsFromValues(
    wifi: PSWiFiKext, bootPlist: Bool, legacyUSB: Bool, hd3000: Bool,
    hda: Bool, bcm5701: Bool, gfTesla: Bool, nvNet: Bool, mccs: Bool,
    agc: Bool, vit9696: Bool, backlight: Bool, fixup: Bool,
    telemetry: Bool, snb: PSSNBKext, acceleration: Bool
) -> String {
    print("Generating PatchSystem.sh arguments...")
    var arguments = ""
    if wifi != .none {
        switch wifi {
        case .mojaveHybrid: arguments.append(" --wifi=mojaveHybrid")
        case .hv12vOld: arguments.append(" --wifi=hv12vOld")
        case .hv12vNew: arguments.append(" --wifi=hv12vNew")
        case .nativePlus: arguments.append(" --wifi=nativePlus")
        case .none: break
        }
    }
    if bootPlist { arguments.append(" --bootPlist") }
    if legacyUSB { arguments.append(" --legacyUSB") }
    if hd3000 { arguments.append(" --hd3000") }
    if hda { arguments.append(" --hda") }
    if bcm5701 { arguments.append(" --bcm5701") }
    if gfTesla { arguments.append(" --gfTesla") }
    if nvNet { arguments.append(" --nvNet") }
    if mccs { arguments.append(" --mccs") }
    if agc { arguments.append(" --agc") }
    if vit9696 { arguments.append(" --vit9696") }
    if backlight { arguments.append(" --backlight") }
    if fixup { arguments.append(" --backlightFixup") }
    if telemetry { arguments.append(" --telemetry") }
    if snb != .none {
        arguments.append(snb == .kext ? " --smb=kext" : " --smb=bundle")
    }
    if acceleration { arguments.append(" --openGL") }
    print("Will use:\(arguments)")
    return arguments
}
