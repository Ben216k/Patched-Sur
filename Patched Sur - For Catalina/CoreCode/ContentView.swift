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
    
    enum PIPages {
        case welcome
        case express
        case advancedSelect
        case selectMacVersion
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
            }
            Spacer()
            Divider()
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
                                    os_log("Unable to go back in first screen.", log: OSLog.ui, type: .info)
                                case .express:
                                    page = .welcome
                                case .advancedSelect:
                                    page = .express
                                case .selectMacVersion:
                                    page = .advancedSelect
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
                                    page = .welcome
                                case .advancedSelect:
                                    page = .selectMacVersion
                                case .selectMacVersion:
                                    page = .welcome
                                }
                            }
                        }.inPad()
                    }
                }
                
                // MARK: -
            }.padding(.top, 2)

        }.padding().frame(width: 600, height: 325)
    }
}
