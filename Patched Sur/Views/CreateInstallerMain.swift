//
//  CreateInstallerMain.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/4/21.
//

import VeliaUI

struct CreateInstallerOverView: View {
    @State var progress = PSPage.main
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
    @Binding var at: Int
    
    var body: some View {
        ZStack {
            Color.clear
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: "Create Installer", s: "v\(AppInfo.version) (\(AppInfo.build))", c: $compressed)
                        .alignment(.leading)
                    Spacer()
                    if progress != .done {
                        VIButton(id: "BACKBUTTON", h: $hovered) {
                            Image("BackArrow")
                                .resizable()
                                .frame(width: compressed ? 10 : 15, height: compressed ? 10 : 15)
                                .scaleEffect(compressed ? 1.2 : 1)
                        } onClick: {
                            switch backConfirm() {
                            case .confirm:
                                backConfirm = { .confirm }
                                if progress == .track {
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
                                } else if progress == .main {
                                    withAnimation {
                                        at = 0
                                    }
                                } else {
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
                        CreateInstallerMain(p: $progress, c: $compressed).transition(.moveAway)
//                    case .credits:
//                        CreditsView(p: $progress).transition(.moveAway)
//                    case .remember:
//                        RememberPleaseView(p: $progress).transition(.moveAway)
//                    case .verify:
//                        MacCompatibility(p: $progress).transition(.moveAway)
                    case .track:
                        ReleaseTrackView(track: $releaseTrack, p: $progress, isPost: true).transition(.moveAway)
                    case .macOS:
                        macOSConfirmView(p: $progress, installInfo: $installInfo, track: $releaseTrack)
//////                    case 10:
//////                        InstallMethodView(method: $installMethod, p: $progress).transition(.moveAway)
                    case .kexts:
                        DownloadKextsView(p: $progress, hasKexts: $hasKexts, onExit: $backConfirm, isPost: true, installInfo: $installInfo).transition(.moveAway)
                    case .package:
                        macOSDownloadView(p: $progress, installInfo: $installInfo, onExit: $backConfirm, isPost: true)
                    case .volume:
                        VolumeSelector(p: $progress, volume: $volume, onExit: $backConfirm, isPost: true).transition(.moveAway)
                    case .create:
                        CreateInstallerView(p: $progress, password: $password, showPass: $showPass, volume: $volume, installInfo: $installInfo, onExit: $backConfirm).transition(.moveAway)
                    case .done:
                        DoneView(at: $at)
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

struct CreateInstallerMain: View {
    @State var hovered: String?
    @Binding var p: PSPage
    @Binding var c: Bool
    
    var body: some View {
        VStack {
            Text("Create macOS Installer")
                .font(.system(size: 15)).bold()
            Text("This tool allows you to create a Patched Sur patched macOS Big Sur installer USB, similar to how the pre-install app does it, except with a couple of changes. This can definitely be used as a just in case if you run into a problem later with the patcher. Note that you can install a recovery partition that is pretty similar to this, however currently it cannot reinstall macOS since there is no WiFi in recovery, but this can. Also note that if you are using this to upgrade, there is an easier way, which is the post-install app.")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            VIButton(id: "GETSTARTED", h: $hovered) {
                Text("Get Started")
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .track
                    c = true
                }
            }.inPad()
        }
    }
}

struct DoneView: View {
    @State var hovered: String?
    @Binding var at: Int
    var body: some View {
        VStack {
            Text("Finished Creating a macOS Installer")
            Text("This installer can now be used for whatever you wanted to use it for. It is fully patched just like how it would be if you made it with the pre-install app. It contains the macOS installer (hopefully you know that), a full recovery mode environment, and of course Patched Sur for patching the kexts.")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            VIButton(id: "HOME", h: $hovered) {
                Image(systemName: "circle.grid.3x3")
                    .font(Font.system(size: 15).weight(.medium))
                Text("Go Home")
            } onClick: {
                withAnimation {
                    at = 0
                }
            }.inPad()
        }
    }
}

enum PSPage: Int {
    case main = 0
    case track = 1
    case macOS = 2
    case kexts = 3
    case package = 4
    case volume = 5
    case create = 6
    case done = 7
    case random = 100000
}

enum BackMode {
    case cancel
    case confirm
}
