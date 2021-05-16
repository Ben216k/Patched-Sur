//
//  PatchKextsActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/3/21.
//

import Foundation

// MARK: Detect Patches

func detectPatches(installerName: (String?) -> (), legacy: (Bool) -> ()) {
    // Detect Patched-Sur-Patches
    print("Checking for USB at \"/Volumes/Install macOS Big Sur Beta/KextPatches\"...")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur Beta/KextPatches' ]]")) != nil {
        print("Found PSPatches at Beta path")
        installerName("'/Volumes/Install macOS Big Sur Beta'")
        return
    }
    print("Checking for USB at \"/Volumes/Install macOS Big Sur/KextPatches\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur/KextPatches' ]]")) != nil {
        print("Found PSPatches at Regular path")
        installerName("'/Volumes/Install macOS Big Sur'")
        return
    }
    print("Checking for kexts at \"/usr/local/lib/Patched-Sur-Patches/KextPatches")
    if (try? call("[[ -d /usr/local/lib/Patched-Sur-Patches/KextPatches ]]")) != nil {
        print("Found pre-downloaded kexts!")
        installerName("/usr/local/lib/Patched-Sur-Patches/Scripts")
        return
    }
    
    // Detect micropatcher (Legacy)
    print("Checking for micropatcher kexts at \"/Volumes/Install macOS Big Sur Beta/kexts\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur Beta/kexts' ]]")) != nil {
        print("Found micropatcher at legacy Beta path")
        print("It is! This will be used even though it is the last resort.")
        installerName("'/Volumes/Install macOS Big Sur Beta'")
        legacy(true)
        return
    }
    print("Checking for micropatcher kexts at \"/Volumes/Install macOS Big Sur/kexts\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur/kexts' ]]")) != nil {
        print("Found micropatcher at legacy regular path")
        print("It is! This will be used even though it is the last resort.")
        installerName("'/Volumes/Install macOS Big Sur'")
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
            let log = (legacy ? "Warning: Legacy Patch Kexts Mode was used.\n" : "") + error.localizedDescription
            errorX(log)
        }
    } else {
        print("YOU WANT ME TO PATCH THE KEXTS?! I'm sleeping for 5 seconds instead.")
        sleep(5)
        errorX(nil)
    }
}

func patchSystem(password: String, arguments: String, location: String, errorX: (String?) -> ()) {
    if !AppInfo.nothing {
        print("Starting Patch System")
        do {
            let output = try call("\(location)/PatchSystem.sh\(arguments)", p: password)
            UserDefaults.standard.setValue(output, forKey: "PatchKextsLastRun")
            errorX(nil)
        } catch {
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
        arguments.append(wifi == .mojaveHybrid ? " --wifi=mojaveHybrid" : (wifi == .hv12vOld ? " --wifi=hv12vOld" : " --wifi=hv12vNew"))
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
