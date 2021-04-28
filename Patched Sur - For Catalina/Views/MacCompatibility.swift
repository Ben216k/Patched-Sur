//
//  MacCompatibility.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import VeliaUI

// MARK: Top Level

struct MacCompatibility: View {
    @Binding var p: PSPage
    @State var hovered = nil as String?
    @State var info: CompatInfo?
    @State var progress2 = VerifyProgress.downloading
    @State var problems: [ProblemInfo] = []
    @State var known = [] as [Substring]
    @State var alert: Alert?
    
    var body: some View {
        VStack {
            switch progress2 {
            case .downloading, .verifying, .errored:
                VerifyMacView(progress2: $progress2, info: $info, known: $known, problems: $problems)
            case .issues:
                IssuesView(problems: $problems, progress2: $progress2, info: $info)
            case .clean:
                CompatibilityReport(info: $info, known: $known, p: $p)
            case .noCompat:
                NoCompatibilityView(p: $p)
            }
        }
    }
}

// MARK: Verifier

struct VerifyMacView: View {
    @State var barProgress = 0.1 as CGFloat
    @Binding var progress2: VerifyProgress
    @State var errorX = ""
    @Binding var info: CompatInfo?
    @Binding var known: [Substring]
    @Binding var problems: [ProblemInfo]
    
    var body: some View {
        VStack {
            Text(.init("PRE-VERIFY-MAC"))
                .font(.system(size: 15)).bold()
            Text(.init("PRE-VERIFY-QUICK"))
                .padding(.vertical)
                .multilineTextAlignment(.center)
            ZStack {
                ProgressBar(value: $barProgress, length: 200)
                HStack {
                    if progress2 == .downloading {
                        Image("DownloadArrow")
                        Text(.init("PRE-VERIFY-FETCH"))
                            .onAppear {
                                DispatchQueue(label: "FetchCompat").async {
                                    downloadCompat(info: &info, known: &known, barProgress: { barProgress = $0 }, progress2: &progress2, errorX: &errorX)
                                }
                            }
                    } else if progress2 == .verifying {
                        Image("CheckCircle")
                        Text(.init("PRE-VERIFY-2"))
                            .onAppear {
                                DispatchQueue(label: "VerifyMac").async {
                                    verifyCompat(barProgress: { barProgress = $0 }, problems: { problems.append($0) }, progress2: &progress2, errorX: &errorX, info: info)
                                }
                            }
                    }
                }.foregroundColor(.white)
                .padding(7)
            }.fixedSize()
        }
    }
}

// MARK: Compatibility Report

struct CompatibilityReport: View {
    @Environment(\.colorScheme) var scheme
    @Binding var info: CompatInfo?
    @Binding var known: [Substring]
    @State var hovered: String?
    @Binding var p: PSPage
    
    var body: some View {
        VStack {
            Text(info!.macName)
                .font(.system(size: 17)).bold()
                .padding(.bottom, -2)
            HStack(spacing: 1) {
                Text(.init("PRE-REPORT-BY"))
                ZStack {
                    if known.contains(Substring(info!.author)) {
                        Rectangle()
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .opacity(scheme == .light ? 1 : 0.8)
                    }
                    HStack(spacing: 1) {
                        Text(info!.author).bold()
                    }.foregroundColor(known.contains(Substring(info!.author)) ? .white : .primary)
                    .padding(known.contains(Substring(info!.author)) ? 1 : 0)
                    .padding(.horizontal, known.contains(Substring(info!.author)) ? 3 : 0)
                }.fixedSize()
                if info!.approved.count > 0 {
                    Text(" (\(info!.approved.count) \(info!.approved.count == 1 ? NSLocalizedString("PERSON", comment: "person") : NSLocalizedString("OTHERS", comment: "others")) \(info!.approved.count == 1 ? NSLocalizedString("APPROVES", comment: "approves") : NSLocalizedString("APPROVE", comment: "approve")))")
                }
            }.font(.system(size: 11))
            Text(info!.details)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 2)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 1.5) {
                    ForEach(info!.works, id: \.self) { item in
                        HStack {
                            Rectangle()
                                .foregroundColor(.green)
                                .frame(width: 10, height: 10)
                                .cornerRadius(10)
                            Text(.init(item))
                                .font(.system(size: 12))
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 1.5) {
                    ForEach(info!.unknown, id: \.self) { item in
                        HStack {
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 10, height: 10)
                                .cornerRadius(10)
                            Text(.init(item))
                                .font(.system(size: 11.5))
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 1.5) {
                    ForEach(info!.warns, id: \.self) { item in
                        HStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .frame(width: 10, height: 10)
                                .cornerRadius(10)
                            Text(.init(item))
                                .font(.system(size: 12))
                        }
                    }
                }
            }
            VIButton(id: "CONTINUE1", h: $hovered) {
                Text(.init("CONTINUE"))
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .track
                }
            }.inPad()
            .padding(.top, 10)
        }
    }
}

// MARK: Issues View

struct IssuesView: View {
    @Binding var problems: [ProblemInfo]
    @State var hovered: String?
    @State var showAreYouSure = false
    @Binding var progress2: VerifyProgress
    @Binding var info: CompatInfo?
    
    var body: some View {
        VStack {
            ScrollView {
                if problems[0].severity != .warning {
                    Text(problems[0].severity == .fatal ? .init("PROB-FATAL") : .init("PROB-WARN"))
                        .bold()
                    Text(problems[0].title)
                        .font(.system(size: 17)).bold()
                        .padding(5)
//                        .onAppear {
//                            background = (problems[0].severity == .fatal ? Color.red : Color.orange).opacity(0.1)
//                        }
                    Text(problems[0].description)
                        .frame(width: 540)
                        .multilineTextAlignment(.center)
                    if problems.map(\.severity).contains(.fatal) {
                        Text(.init("PROB-NO-UPGRADE"))
                            .bold()
                            .padding(.vertical, 10)
                    } else {
                        VIButton(id: "CONTINUE", h: $hovered) {
                            Text(.init("PROB-CONTINUE-ANYWAY"))
                            Image("ForwardArrowCircle")
                        } onClick: {
                            showAreYouSure = true
                        }.inPad()
                        .padding(.vertical, 10)
                    }
                }
                if problems.count > 1 {
                    Text(.init("PROB-OTHERS"))
                        .bold()
                        .padding(.bottom, 10)
                    ForEach(problems.filter { $0.title != problems[0].title }, id: \.title) { item in
                        Text(item.title)
                            .bold()
                        Text(item.description)
                            .frame(width: 540)
                    }
                }
            }.frame(maxHeight: 250).fixedSize()
        }.alert(isPresented: $showAreYouSure) {
            Alert(title: Text(.init("PROB-SURE")), message: Text(.init("PROB-SURE-SURE")), primaryButton: .destructive(Text("Continue"), action: {
                progress2 = info != nil ? .clean : .noCompat
            }), secondaryButton: .cancel())
        }
    }
}

// MARK: No Compatibility

struct NoCompatibilityView: View {
    @State var hovered: String?
    @Binding var p: PSPage
    
    var body: some View {
        Text(.init("REPORT-UNKNOWN"))
            .font(.system(size: 15)).bold()
        Text(.init("REPORT-UNKNOWN-2"))
            .padding(.vertical)
            .multilineTextAlignment(.center)
            .frame(width: 540)
        VIButton(id: "CONTINUE3", h: $hovered) {
            Text(.init("CONTINUE"))
            Image("ForwardArrowCircle")
        } onClick: {
            withAnimation {
                p = .track
            }
        }.inPad()
    }
}

enum VerifyProgress {
    case downloading
    case verifying
    case issues
    case clean
    case noCompat
    case errored
}

extension Array where Element : Equatable {
    func contains(oneOf: [Element]) -> Bool {
        var result = false
        forEach { item in
            result = result ? true : oneOf.contains(item)
        }
        return result
    }
}

/*
 Error 1x2
 2021-01-18 22:31:31.190831-0700 fdesetup[3384:124769] [ManagedClient] fdesetup: command = status
 2021-01-18 22:31:31.272683-0700 fdesetup[3384:124769] [ManagedClient] fdesetup: no user approved profile was passed
 2021-01-18 22:31:31.272714-0700 fdesetup[3384:124769] [ManagedClient] fdesetup:: status
 /Users/bensova/.patched-sur/DetectProblems.sh: line 130: syntax error: unexpected end of file
 */
