//
//  CentralView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import VeliaUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            AllViews()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AllViews : View {
    @State var progress = PSPage.main
    @State var password = ""
    @State var volume = ""
    @State var overrideinstaller = false
    @State var releaseTrack = ReleaseTrack.release
    @State var installMethod = InstallMethod.update
    @State var installInfo = nil as InstallAssistant?
    @State var useCurrent = false
    @State var packageLocation = "~/.patched-sur/InstallAssistant.pkg"
    @State var appLocation = nil as String?
    @State var compressed = false
    @State var hovered: String?
    @State var background = Color.clear
    
    var body: some View {
        ZStack {
            background
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: "Patched Sur", s: "v\(AppInfo.version) (\(AppInfo.build))", c: $compressed)
                        .alignment(.leading)
                    Spacer()
                    if compressed {
                        VIButton(id: "BACKBUTTON", h: $hovered) {
                            Image("BackArrow")
                                .resizable()
                                .frame(width: compressed ? 10 : 15, height: compressed ? 10 : 15)
                                .scaleEffect(compressed ? 1.2 : 1)
                        } onClick: {
                            background = Color.clear
                            if progress == .verify {
                                withAnimation {
                                    progress = .main
                                    compressed = false
                                }
                            } else if progress == .volume {
                                withAnimation {
                                    progress = .macOS
                                }
                            } else if progress != .main {
                                withAnimation {
                                    progress = PSPage(rawValue: progress.rawValue - 1)!
                                }
                            }
                        }
                    }
                    VIButton(id: "GITHUB", h: $hovered) {
                        Image("GitHubMark")
                            .resizable()
                            .frame(width: compressed ? 10 : 15, height: compressed ? 10 : 15)
                            .scaleEffect(compressed ? 1.2 : 1)
                    } onClick: {
                        NSWorkspace.shared.open(URL(string: "https://github.com/BenSova/Patched-Sur")!)
                    }
                }
                .padding(.top, compressed ? 35 : 40)
                Spacer()
                Group {
                    switch progress {
                    case .main:
//                        ZStack {
                            MainView(hovered: $hovered, p: $progress, c: $compressed).transition(.moveAway)
        //                    EnterPasswordPrompt(password: $password, show: .constant(true))
//                        }
                    case .verify:
                        MacCompatibility(p: $progress, background: $background).transition(.moveAway)
//                    case 2:
//                        HowItWorks(p: $progress).transition(.moveAway)
                    case .track:
                        ReleaseTrackView(track: $releaseTrack, p: $progress).transition(.moveAway)
                    case .macOS:
                        macOSConfirmView(p: $progress, installInfo: $installInfo, track: $releaseTrack)
////                    case 10:
////                        InstallMethodView(method: $installMethod, p: $progress).transition(.moveAway)
//                    case .kexts:
//                        DownloadView(p: $progress).transition(.moveAway)
//                    case .macOS:
//                        InstallPackageView(installInfo: $installInfo, password: $password, p: $progress, overrideInstaller: $overrideinstaller, track: $releaseTrack, useCurrent: $useCurrent, package: $packageLocation, installer: $appLocation).transition(.moveAway)
//                    case .volume:
//                        VolumeSelector(p: $progress, volume: $volume).transition(.moveAway)
////                    case .:
////                        ConfirmVolumeView(volume: $volume, p: $progress).transition(.moveAway)
//                    case .create:
//                        CreateInstallMedia(volume: $volume, password: $password, overrideInstaller: $overrideinstaller, p: $progress, installer: $appLocation).transition(.moveAway)
//                    case .done:
//                        FinishedView(app: appLocation ?? "/Applications/Install macOS Big Sur Beta.app/").transition(.moveAway)
//                    case .packages:
//                        InstallerChooser(p: $progress, installInfo: $installInfo, track: $releaseTrack, useCurrent: $useCurrent, package: $packageLocation, installer: $appLocation).transition(.moveAway)
                    default:
                        Text("Uh-oh Looks like you went to the wrong page. Error 0x\(progress.hashValue)").transition(.moveAway)
                    }
                }
                .padding(.bottom, 10)
                Spacer()
            }.padding(.horizontal, 30)
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Text("v\(AppInfo.version) (\(AppInfo.build))")
//                        .font(.caption)
//                        .padding()
//                }
//            }
        }.edgesIgnoringSafeArea(.all)
        .frame(width: 600, height: 325)
    }
}

enum PSPage: Int {
    case main = 0
    case verify = 1
    case track = 2
    case macOS = 3
    case kexts = 4
    case packages = 5
    case volume = 6
    case create = 7
    case done = 8
}

enum ReleaseTrack: String, CustomStringConvertible {
    case release = "Release"
    case publicbeta = "Public Beta"
    case developer = "Developer"
    
    var description: String {
        rawValue
    }
}
