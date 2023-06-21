//
//  ExpressSetupView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import SwiftUI

struct ExpressSetupView: View {
    @State var hasDetectedProperties = false
    @Binding var isShowingButtons: Bool
    @Binding var problemInfo: ProblemInfo?
    @Binding var installInfo: InstallAssistant?
    @Binding var installAssistants: [InstallAssistant]
    
    var body: some View {
        Group {
            if hasDetectedProperties {
                ExpressContinueView(installInfo: $installInfo)
            } else {
                if problemInfo == nil {
                    ExpressLoadingView(isShowingButtons: $isShowingButtons, hasDetectedProperties: $hasDetectedProperties, problemInfo: $problemInfo, installAssistants: $installAssistants, installInfo: $installInfo)
                } else {
                    ExpressCompatErrorView(problemInfo: $problemInfo)
                }
            }
        }
    }
}

struct ExpressContinueView: View {
    @Binding var installInfo: InstallAssistant?
    
    var body: some View {
        VStack {
            Spacer()
            Text("Express Setup")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            Text("Upgrading ") + Text("This Mac").bold() + Text(" to ") + Text("macOS Big Sur \(installInfo!.version)").bold() + Text(" using files ") + Text("sourced from Apple.").bold()
            Text("If you'd like to change any of the above information (i.e. selecting a different Mac, macOS version, or using a local copy of the installer) click Advanced. The majority of users will not need this option.")
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .padding(.horizontal)
            Spacer()
        }.padding(.bottom)
    }
}

struct ExpressLoadingView: View {
    @Binding var isShowingButtons: Bool
    @Binding var hasDetectedProperties: Bool
    @State var progress: CGFloat = 0.5
    @Binding var problemInfo: ProblemInfo?
    @Binding var installAssistants: [InstallAssistant]
    @Binding var installInfo: InstallAssistant?
    @State var errorX: String?
    @State var isOnStepTwo = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Loading Configuration")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            if let errorX {
                ErrorHandlingView(bubble: "An error occured fetching the list of installers for macOS Big Sur or the link to the patches to be used by this patcher. Please check your network connection and try again.", fullError: errorX)
            } else {
                Text("Patched Sur is quickly analyzing this Mac to check compatability and obtaining information about the latest macOS and patch version. This should be quick.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                ZStack {
                    ProgressBar(value: $progress, length: 200)
                    if isOnStepTwo {
                        HStack {
                            Image("RefreshCircle")
                            Text("Fetching Installers")
                        }.foregroundColor(.white)
                            .padding(7)
                    } else {
                        HStack {
                            Image("CheckCircle")
                            Text("Checking Compatability")
                        }.foregroundColor(.white)
                            .padding(7)
                    }
                }.fixedSize()
            }
            Spacer()
                .onAppear {
                    withAnimation {
                        isShowingButtons = false
                    }
                    DispatchQueue.global(qos: .background).async {
                        verifyCompat(barProgress: { pro in
                            withAnimation { progress = pro }
                        }, problems: { heart in withAnimation { problemInfo = heart; isShowingButtons = true } })
                        guard problemInfo == nil else { return }
                        isOnStepTwo = true
                        let installers = fetchInstallers { errorx in
                            print(errorx)
                            errorX = errorx
                        }
                        withAnimation { progress = 0.9 }
                        installAssistants = installers
                        installInfo = installers.first
                        withAnimation { progress = 1 }
                        withAnimation {
                            hasDetectedProperties = true
                            isShowingButtons = true
                        }
                    }
                }
        }.padding(.bottom, 5)
    }
}

struct ExpressCompatErrorView: View {
    @Binding var problemInfo: ProblemInfo?
    
    var body: some View {
        VStack {
            Spacer()
            if let problemInfo {
                (Text("Compatability Error: ") + Text(.init(problemInfo.title)))
                    .font(.system(size: 17, weight: .bold))
                    .padding(.bottom, 10)
                Text(.init(problemInfo.description))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            Text(.init("PROB-NO-UPGRADE"))
                .bold()
                .padding(.top, 10)
            Spacer()
        }.padding(.bottom, 5)
    }
}
