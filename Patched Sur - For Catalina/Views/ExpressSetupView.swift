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
    @State var problemInfo: ProblemInfo?
    
    var body: some View {
        Group {
            if hasDetectedProperties {
                ExpressContinueView()
            } else {
                if problemInfo == nil {
                    ExpressLoadingView(isShowingButtons: $isShowingButtons, problemInfo: $problemInfo)
                } else {
                    ExpressCompatErrorView(problemInfo: $problemInfo)
                }
            }
        }
    }
}

struct ExpressContinueView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Express Setup")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            Text("Upgrading ") + Text("This Mac").bold() + Text(" to ") + Text("macOS Big Sur 11.7.7").bold() + Text(" using files ") + Text("sourced from Apple.").bold()
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
    @State var progress: CGFloat = 0.5
    @Binding var problemInfo: ProblemInfo?
    
    var body: some View {
        VStack {
            Spacer()
            Text("Loading Configuration")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            Text("Patched Sur is quickly analyzing this Mac to check compatability and obtaining information about the latest macOS and patch version. This should be quick.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 10)
            ZStack {
                ProgressBar(value: $progress, length: 200)
                HStack {
                    Image("CheckCircle")
                    Text("Checking Compatability")
                }.foregroundColor(.white)
                    .padding(7)
            }.fixedSize()
            Spacer()
                .onAppear {
                    withAnimation {
                        isShowingButtons = false
                    }
                    DispatchQueue.global(qos: .background).async {
                        verifyCompat(barProgress: { pro in
                            withAnimation { progress = pro }
                        }, problems: { problemInfo = $0 })
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
