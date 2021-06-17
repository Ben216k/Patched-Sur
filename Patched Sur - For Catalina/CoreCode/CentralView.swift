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
                .frame(width: 600, height: 325)
        }
    }
}

struct AllViews : View {
    @State var progress = PSPage.volume
    @State var password = ""
    @State var volume = ""
    @State var overrideinstaller = false
    @State var releaseTrack = ReleaseTrack.release
    @State var installInfo = nil as InstallAssistant?
    @State var useCurrent = false
    @State var packageLocation = "~/.patched-sur/InstallAssistant.pkg"
    @State var appLocation = nil as String?
    @State var compressed = false
    @State var hovered: String?
    @State var hasKexts = false
    @State var showPass = false
    @State var backConfirm: (() -> (BackMode)) = { .confirm }
    @State var goTo = PSPage.main
    
    var body: some View {
        ZStack {
            Color.clear
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: "Patched Sur", s: "v\(AppInfo.version) (\(AppInfo.build))", c: $compressed)
                        .alignment(.leading)
                    Spacer()
                    if compressed && (progress != .done) {
                        VIButton(id: "BACKBUTTON", h: $hovered) {
                            Image("BackArrow")
                                .resizable()
                                .frame(width: compressed ? 10 : 15, height: compressed ? 10 : 15)
                                .scaleEffect(compressed ? 1.2 : 1)
                        } onClick: {
                            switch backConfirm() {
                            case .confirm:
                                backConfirm = { .confirm }
                                if progress == .credits {
                                    withAnimation {
                                        progress = .main
                                        compressed = false
                                    }
                                } else if progress == .volume {
                                    withAnimation {
                                        progress = .macOS
                                    }
                                } else if progress == .package {
                                    withAnimation {
                                        progress = .macOS
                                    }
                                } else if progress != .main {
                                    withAnimation {
                                        progress = PSPage(rawValue: progress.rawValue - 1)!
                                    }
                                }
                                backConfirm = { .confirm }
                            case .cancel:
                                return
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
                        MainView(hovered: $hovered, p: $progress, c: $compressed).transition(.moveAway)
                    case .credits:
                        CreditsView(p: $progress).transition(.moveAway)
                    case .remember:
                        RememberPleaseView(p: $progress).transition(.moveAway)
                    case .verify:
                        MacCompatibility(p: $progress).transition(.moveAway)
                    case .track:
                        ReleaseTrackView(track: $releaseTrack, p: $progress, isPost: false).transition(.moveAway)
                    case .macOS:
                        macOSConfirmView(p: $progress, installInfo: $installInfo, track: $releaseTrack)
////                    case 10:
////                        InstallMethodView(method: $installMethod, p: $progress).transition(.moveAway)
                    case .kexts:
                        DownloadKextsView(p: $progress, hasKexts: $hasKexts, onExit: $backConfirm, isPost: false, installInfo: $installInfo).transition(.moveAway)
                    case .package:
                        macOSDownloadView(p: $progress, installInfo: $installInfo, onExit: $backConfirm, isPost: false)
                    case .volume:
                        VolumeSelector(p: $progress, volume: $volume, onExit: $backConfirm, isPost: false).transition(.moveAway)
                    case .create:
                        CreateInstallerView(p: $progress, password: $password, showPass: $showPass, volume: $volume, installInfo: $installInfo, onExit: $backConfirm).transition(.moveAway)
                    case .done:
                        DoneView()
                    case .random:
                        Text("Restarting View...")
                            .onAppear {
                                progress = goTo
                            }
//                    default:
//                        Text("Uh-oh Looks like you went to the wrong page. Error 0x\(progress.hashValue)").transition(.moveAway)
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
            EnterPasswordPrompt(password: $password, show: $showPass) {
                
            }
        }.edgesIgnoringSafeArea(.all)
        .frame(width: 600, height: 325)
    }
}

enum PSPage: Int {
    case main = 0
    case credits = 1
    case remember = 2
    case verify = 3
    case track = 4
    case macOS = 5
    case kexts = 6
    case package = 7
    case volume = 8
    case create = 9
    case done = 10
    case random = 100000
}

enum ReleaseTrack: String, CustomStringConvertible {
    case release = "Release"
    case publicbeta = "Public Beta"
    case developer = "Developer"
    
    var description: String {
        rawValue
    }
}

enum BackMode {
    case cancel
    case confirm
}
