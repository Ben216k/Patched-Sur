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
    @State var downloadProgress: CGFloat = 0.5
    
    enum PIPages {
        case welcome
        case express
        case advancedSelect
        case selectMacVersion
        case download
    }
    
    var body: some View {
        
        // Dear Apple: Why was there no actual navigation thing for paging stuff?
        
        VStack {
            HStack {
                VIHeader(p: "Patched Sur", s: "By Ben216k", c: .init(get: { page != .welcome }, set: {_ in}))
                    .alignment(.leading)
                Spacer()
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
            case .download:
                DownloadingView(isShowingButtons: $isShowingButtons, installInfo: $installInfo, showMoreInformation: $showMoreInformation, progress: $downloadProgress)
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
                            
                        } label: {
                            Image("GitHubMark")
                        }.buttonStyle(.borderless)
                        Button {
                            
                        } label: {
                            Image("GitHubMark")
                        }.buttonStyle(.borderless)
                    }
                    Text("v2.0.0 (125)")
                        .font(.caption)
                }
                Spacer()
                
                // MARK: - Navigation Buttons
                
                if isShowingButtons {
                    if page != .welcome && !(problemInfo != nil && page == .express) {
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
                                case .download:
                                    OSLog.ui.log("Unable to navigate back while in download view", type: .error)
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
                    if !(problemInfo != nil && page == .express) && !(page == .advancedSelect && selectedMac == nil) {
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
                                    page = .download
                                case .advancedSelect:
                                    page = .selectMacVersion
                                case .selectMacVersion:
                                    page = .download
                                case .download:
                                    OSLog.ui.log("Unable to navigate forward while in download view", type: .error)
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
                
                // MARK: -
            }.padding(.top, 2)

        }.padding().frame(width: 600, height: 325)
    }
}
