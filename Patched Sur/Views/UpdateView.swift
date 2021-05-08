//
//  UpdateView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/24/20.
//

import VeliaUI
import Files

struct UpdateView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var at: Int
    @State var progress = 0
    @State var installers = nil as InstallAssistants?
    @State var track = ReleaseTrack.release
    @State var latestPatch = nil as PatchedVersion?
    #if DEBUG
    @State var skipAppCheck = false
    #else
    @State var skipAppCheck = false
    #endif
    @State var installInfo = nil as InstallAssistant?
    @State var packageLocation = "~/.patched-sur/InstallAssistant.pkg"
    @State var password = ""
    @State var useCurrent = false
    let buildNumber: String
    @State var topCompress = false
    @State var hovered: String?
    @State var showPassPrompt = false
    @State var osVersion = ""
    
    var body: some View {
        ZStack {
            VStack {
                if progress != 5 {
                    HStack(spacing: 15) {
                        VIHeader(p: progress == 1 ? NSLocalizedString("PO-UP-TITLE-PATCHER", comment: "PO-UP-TITLE-PATCHER") : NSLocalizedString("PO-UP-TITLE-MACOS", comment: "PO-UP-TITLE-MACOS"), s: "v\(AppInfo.version) (\(AppInfo.build))", c: $topCompress)
                            .alignment(.leading)
                        Spacer()
                        if progress != 4 {
                            VIButton(id: "BACK", h: $hovered) {
                                Image("BackArrow")
                                    .resizable()
                                    .frame(width: topCompress ? 10 : 15, height: topCompress ? 10 : 15)
                                    .scaleEffect(topCompress ? 1.2 : 1)
                            } onClick: {
                                if progress == 3 {
                                    _ = try? call("killall curl")
                                }
                                withAnimation {
                                    at = 0
                                }
                            }
                        }
                    }.padding(.top, 40)
                    Spacer(minLength: 0)
                }
                switch progress {
                case 0:
                    UpdateCheckerView(at: $at, progress: $progress, installers: $installers, track: $track, latestPatch: $latestPatch, skipAppCheck: $skipAppCheck, installInfo: $installInfo, topCompress: $topCompress).transition(.moveAway)
                        .onAppear {
                            osVersion = (try? call("sw_vers -productVersion")) ?? "11.xx.yy"
                        }
                case 1:
                    UpdateAppView(latest: latestPatch!, p: $progress, skipCheck: $skipAppCheck).transition(.moveAway)
                case -1:
                    Text("Hi You! You shouldn't really be seeing this, but here you are!")
                        .onAppear {
                            withAnimation {
                                progress = 0
                                at = 0
                            }
                        }.transition(.moveAway)
                case 2:
                    UpdateOSView(installers: installers, installInfo: $installInfo, releaseTrack: $track, buildNumber: buildNumber, osVersion: osVersion, p: $progress, showPass: $showPassPrompt, password: $password).transition(.moveAway)
                case 3:
                    DownloadView(p: $progress, installInfo: $installInfo, useCurrent: $useCurrent, showPassPrompt: $showPassPrompt, password: $password).transition(.moveAway)
                case 4:
                    StartInstallView(password: $password, installInfo: $installInfo).transition(.moveAway)
                case 5:
                    UpdateChooser(p: $progress, installInfo: $installInfo, track: $track, useCurrent: $useCurrent, package: $packageLocation).transition(.moveAway)
//                case 6:
//                    DisableAMFIView().transition(.moveAway)
//                case 8:
//                    NotificationsView(p: $progress).font(.caption).transition(.moveAway)
                default:
                    Text("Sad")
                }
                Spacer(minLength: 0)
            }
            .navigationTitle("Patched Sur")
            .padding(.horizontal, 30)
            EnterPasswordPrompt(password: $password, show: $showPassPrompt) {
            }
        }
    }
}

//            case 5:
//                InstallerChooser()

enum ReleaseTrack: String, CustomStringConvertible {
    case release = "Release"
    case developer = "Developer"
    
    var description: String { rawValue }
}

struct UpdateCheckerView: View {
    @Binding var at: Int
    @Binding var progress: Int
    @Binding var installers: InstallAssistants?
    @Binding var track: ReleaseTrack
    @Binding var latestPatch: PatchedVersion?
    @Binding var skipAppCheck: Bool
    @Binding var installInfo: InstallAssistant?
    @State var checkingForUpdatesText = "Checking For Updates..."
    @State var buttonBG = Color.accentColor
    @Binding var topCompress: Bool
    @State var hovered: String?
    
    var body: some View {
        VStack {
            if checkingForUpdatesText == "Checking For Updates..." {
                Text(NSLocalizedString("PO-UP-CHECKING", comment: "PO-UP-CHECKING"))
                    .font(.title2)
                    .fontWeight(.semibold)
                ProgressView()
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            do {
                                print("Checking for updates to Patched Sur...")
                                if !skipAppCheck, let patchedVersions = try? PatchedVersions(fromURL: "https://api.github.com/repos/BenSova/Patched-Sur/releases").filter({ !$0.prerelease }) {
                                    if patchedVersions[0].tagName != "v\(AppInfo.version)" {
                                        latestPatch = patchedVersions[0]
                                        withAnimation {
                                            topCompress = true
                                            progress = 1
                                        }
                                        print("Found update \(latestPatch?.tagName ?? "INVALID").")
                                        print("Offering update.\n")
                                        return
                                    }
                                }
                                print("No updates found or user choose to skip the app update check.")
                                print("Figuring out what update track to use...")
                                track = ReleaseTrack(rawValue: UserDefaults.standard.string(forKey: "UpdateTrack") ?? "Release") ?? .release
                                print("Using update track \(track).")
                                print("Pinging installer list to find the latest updates...")
                                installers = try InstallAssistants(fromURL:  URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : "Release").json")!)
                                print("Filtering incompatible installers...")
                                installers = installers!.filter { $0.minVersion <= AppInfo.build }
                                print("Finding latest build...")
                                installers!.sort { $0.orderNumber < $1.orderNumber }
                                installInfo = installers!.last
                                if AppInfo.debug {
                                    print("Latest Build: \(installers!.last!.buildNumber)")
                                    print("Install Info: \(installInfo!.buildNumber)")
                                }
                                print("Switching to show updates screen...")
                                print("")
                                withAnimation {
                                    topCompress = true
                                    progress = 2
                                }
                            } catch {
                                print("Failed to fetch installer list.")
                                print(error.localizedDescription)
                                checkingForUpdatesText = error.localizedDescription
                            }
                        }
                    }
            } else {
                VStack {
                    Text(.init("PO-UP-CHECK-FAILED"))
                        .bold()
                        .padding(.top, -20)
                    Text(.init("PO-UP-CHECK-FAILED-1"))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 0)
                    VIError(checkingForUpdatesText)
//                    Button {
//                        let pasteboard = NSPasteboard.general
//                        pasteboard.declareTypes([.string], owner: nil)
//                        pasteboard.setString(checkingForUpdatesText, forType: .string)
//                    } label: {
//                        ZStack {
//                            Color.red
//                                .cornerRadius(10)
//                                .frame(minWidth: 200, maxWidth: 450)
//                            Text(checkingForUpdatesText)
//                                .foregroundColor(.white)
//                                .lineLimit(6)
//                                .padding(6)
//                                .padding(.horizontal, 4)
//                        }
//                    }.buttonStyle(BorderlessButtonStyle())
//                    .fixedSize()
//                    .frame(minWidth: 200, maxWidth: 450)
//                    Text("Click to Copy")
//                        .font(.caption)
//                        .padding(.bottom, 5)
                    VIButton(id: "BACK", h: $hovered) {
                        Image("BackArrowCircle")
                        Text(.init("BACK"))
                    } onClick: {
                        withAnimation {
                            at = 0
                            checkingForUpdatesText = "Checking For Updates..."
                        }
                    }.inPad()
                    .buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        buttonBG = $0 ? Color.accentColor.opacity(0.7) : Color.accentColor
                    }
                }
                .frame(minWidth: 540, maxWidth: 540, minHeight: 325, maxHeight: 325)
            }
        }
        .fixedSize()
    }
}
