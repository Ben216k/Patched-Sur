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
    @State var progress = 0
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
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: "Patched Sur", s: "v\(AppInfo.version) (\(AppInfo.build))", c: $compressed)
                        .alignment(.leading)
                    Spacer()
                    VIButton(id: "HELP", h: $hovered) {
                        Image("QuestionMark")
                            .resizable()
                            .frame(width: compressed ? 10 : 15, height: compressed ? 10 : 15)
                            .scaleEffect(compressed ? 1.2 : 1)
                    } onClick: {
//                        presentHIW = true
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
                    case 0:
                        ZStack {
                            MainView(hovered: $hovered, p: $progress, c: $compressed).transition(.moveAway)
        //                    EnterPasswordPrompt(password: $password, show: .constant(true))
                        }
                    case 1:
                        MacCompatibility(p: $progress).transition(.moveAway)
                    case 2:
                        HowItWorks(p: $progress).transition(.moveAway)
                    case 9:
                        ReleaseTrackView(track: $releaseTrack, p: $progress).transition(.moveAway)
                    case 10:
                        InstallMethodView(method: $installMethod, p: $progress).transition(.moveAway)
                    case 3:
                        DownloadView(p: $progress).transition(.moveAway)
                    case 4:
                        InstallPackageView(installInfo: $installInfo, password: $password, p: $progress, overrideInstaller: $overrideinstaller, track: $releaseTrack, useCurrent: $useCurrent, package: $packageLocation, installer: $appLocation).transition(.moveAway)
                    case 5:
                        VolumeSelector(p: $progress, volume: $volume).transition(.moveAway)
                    case 6:
                        ConfirmVolumeView(volume: $volume, p: $progress).transition(.moveAway)
                    case 7:
                        CreateInstallMedia(volume: $volume, password: $password, overrideInstaller: $overrideinstaller, p: $progress, installer: $appLocation).transition(.moveAway)
                    case 8:
                        FinishedView(app: appLocation ?? "/Applications/Install macOS Big Sur Beta.app/").transition(.moveAway)
                    case 11:
                        InstallerChooser(p: $progress, installInfo: $installInfo, track: $releaseTrack, useCurrent: $useCurrent, package: $packageLocation, installer: $appLocation).transition(.moveAway)
                    default:
                        Text("Uh-oh Looks like you went to the wrong page. Error 0x\(progress)").transition(.moveAway)
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

enum ReleaseTrack: String, CustomStringConvertible {
    case release = "Release"
    case publicbeta = "Public Beta"
    case developer = "Developer"
    
    var description: String {
        rawValue
    }
}
