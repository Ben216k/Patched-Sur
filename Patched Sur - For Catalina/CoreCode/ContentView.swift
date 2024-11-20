//
//  CentralView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import VeliaUI
import OSLog

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var page: PIPages = .welcome
    @State var hovered: String?
    @State var isShowingButtons = true
    @State var installInfo: InstallAssistant?
    @State var allInstallers: [InstallAssistant] = []
    @State var problemInfo: ProblemInfo?
    @State var selectedMac: String?
    @State var showMoreInformation = false
    @State var downloadProgress: CGFloat = 0
    @State var volume: String = ""
    @State var alert: Alert?
    @State var password: String = ""
    @State var showPasswordPrompt = false
    
    enum PIPages {
        case welcome
        case express
        case advancedSelect
        case selectMacVersion
        case download
        case volume
        case patching
        case done
    }
    
    var body: some View {
        
        // Dear Apple: Why was there no actual navigation thing for paging stuff?
        
        ZStack {
            VStack {
                HStack {
                    VIHeader(p: "Patched Sur", s: "By Ben216k", c: .init(get: { page != .welcome }, set: {_ in}))
                        .alignment(.leading)
                    Spacer()
                    Text("The Hidden Jam")
                        .opacity(0.000001)
                        .alert(isPresented: .init(get: { alert != nil }, set: { _ in alert = nil })) {
                            alert ?? Alert(title: Text("An Unknown Error Occurred"), message: Text("How did we get here?"))
                        }
                }.padding(.leading, 15)
                Spacer()
                switch page {
                case .welcome:
                    WelcomeView().transition(.moveAway)
                case .express:
                    ExpressSetupView(isShowingButtons: $isShowingButtons, problemInfo: $problemInfo, installInfo: $installInfo, installAssistants: $allInstallers).transition(.moveAway)
                case .advancedSelect:
                    SelectMacView(problemInfo: $problemInfo, selectedMac: $selectedMac).transition(.moveAway)
                case .selectMacVersion:
                    SelectMacOSVersionView(installInfo: $installInfo, installAssistants: $allInstallers).transition(.moveAway)
                case .volume:
                    SelectVolumeView(volume: $volume)
                case .download:
                    DownloadingView(isShowingButtons: $isShowingButtons, installInfo: $installInfo, showMoreInformation: $showMoreInformation, page: $page, progress: $downloadProgress)
                case .patching:
                    BuildPatchInstallerView(installInfo: $installInfo, volume: $volume, password: $password, p: $page)
                case .done:
                    DoneView()
                }
                Spacer()
                ZStack(alignment: .leading) {
                    Divider()
                    if page == .download && showMoreInformation {
                        Color.accentColor
                            .frame(width: 568 * downloadProgress, height: 1)
                            
                    }
                }
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        HStack {
                            Button {
                                NSWorkspace.shared.open(URL(string: "https://github.com/Ben216k/Patched-Sur")!)
                            } label: {
                                Image("GitHubMark")
                            }.buttonStyle(.borderless)
                            Button {
                                NSWorkspace.shared.open(URL(string: "https://discord.gg/2DxVn4HDX6")!)
                            } label: {
                                Image("DiscordMark")
                            }.buttonStyle(.borderless)
                        }
                        Text("v2.0.0 (125)")
                            .font(.caption)
                    }
                    Spacer()
                    
                    // MARK: - Navigation Buttons
                    
                    if isShowingButtons {
                        if page != .welcome && !(problemInfo != nil && page == .express) && !(page == .done) {
                            VIButton(id: "back", h: $hovered) {
                                Image("BackArrowCircle")
                                Text(.init("BACK"))
                            } onClick: {
                                withAnimation {
                                    switch page {
                                    case .welcome:
                                        os_log("Unable to go back in first screen.", log: OSLog.ui, type: .error)
                                    case .express:
                                        page = .welcome
                                    case .advancedSelect:
                                        page = .express
                                    case .selectMacVersion:
                                        page = .advancedSelect
                                    case .volume:
                                        page = .selectMacVersion
                                    case .download:
                                        OSLog.ui.log("Unable to navigate back while in download view", type: .error)
                                    case .patching:
                                        OSLog.ui.log("Unable to navigate back while in patching view", type: .error)
                                    case .done:
                                        OSLog.ui.log("Unable to navigate back while in done view", type: .error)
                                    }
                                }
                            }.btColor(.secondary).inPad()
                        }
                        if page == .express {
                            if problemInfo == nil {
                                VIButton(id: "advanced", h: $hovered) {
                                    Image("ToolsCircle")
                                    Text(.init("Advanced"))
                                } onClick: {
                                    withAnimation { page = .advancedSelect }
                                }.btColor(.secondary).inPad()
                            } else {
                                VIButton(id: "useForDifferentMac", h: $hovered) {
                                    Text("Use for Different Mac")
                                    Image("ForwardArrowCircle")
                                } onClick: {
                                    withAnimation { page = .advancedSelect }
                                }.btColor(.secondary).inPad()
                            }
                        }
                        if !(problemInfo != nil && page == .express) && !(page == .advancedSelect && selectedMac == nil) && !(page == .volume && volume == "") && !(page == .done) {
                            VIButton(id: "continue", h: $hovered) {
                                if page == .welcome {
                                    Text(.init("GET-STARTED"))
                                } else {
                                    Text(.init("CONTINUE"))
                                }
                                Image("ForwardArrowCircle")
                            } onClick: {
                                withAnimation {
                                    switch page {
                                    case .welcome:
                                        page = .express
                                    case .express:
                                        page = .volume
                                    case .advancedSelect:
                                        page = .selectMacVersion
                                    case .selectMacVersion:
                                        page = .volume
                                    case .volume:
                                        alert = .init(title: Text(NSLocalizedString("PRE-VOL-ERASED", comment: "PRE-VOL-ERASED").description.replacingOccurrences(of: "VOLUME", with: volume)), message: Text(.init("PRE-VOL-ERASED-2")), primaryButton: .default(Text(.init("CONTINUE"))) {
                                            withAnimation { showPasswordPrompt = true }
                                        }, secondaryButton: .cancel())
                                    case .download:
                                        OSLog.ui.log("Unable to navigate forward while in download view", type: .error)
                                    case .patching:
                                        OSLog.ui.log("Unable to navigate forward while in patching view", type: .error)
                                    case .done:
                                        return
                                    }
                                }
                            }.inPad()
                        }
                    } else if page == .download {
                        VIButton(id: "see-more", h: $hovered) {
                            if showMoreInformation {
                                Image("BackArrowCircle")
                            }
                            Text(showMoreInformation ? "Back To Downlaod" : "Learn About Patched Sur")
                            if !showMoreInformation {
                                Image("ForwardArrowCircle")
                            }
                        } onClick: {
                            withAnimation { showMoreInformation.toggle() }
                        }.inPad().btColor(.secondary)
                    }
                    if page == .done {
                        VIButton(id: "view-steps", h: $hovered) {
                            Text("View Steps on GitHub")
                            Image("ForwardArrowCircle")
                        } onClick: {
                            NSWorkspace.shared.open(URL(string: "https://github.com/Ben216k/Patched-Sur#how-do-i-use-patched-sur")!)
                        }.inPad()
                    }
                    
                    // MARK: -
                }.padding(.top, 2)

            }.padding()
            
            EnterPasswordPrompt(password: $password, show: $showPasswordPrompt) {
                withAnimation {
                    if installInfo?.buildNumber.starts(with: "Custom") ?? false {
                        page = .patching
                    } else {
                        page = .download
                    }
                    showPasswordPrompt = false
                    isShowingButtons = false
                }
            }.edgesIgnoringSafeArea(.top)
        }.frame(width: 600, height: 325)
    }
}
