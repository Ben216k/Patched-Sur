//
//  MacCompatibility.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct MacCompatibility: View {
    @Binding var p: Int
    @State var hovered = nil as String?
    @State var info: CompatInfo?
    @State var progress2 = VerifyProgess.downloading
    @State var problems: ProblemInfo = []
    @State var possible: ProblemInfo?
    @State var known = [] as [Substring]
    var body: some View {
        VStack {
            ZStack {
                Text("Mac Compatibility").bold()
                HStack {
                    Button {
                        if progress2 == .clean {
                            p = 0
                        }
                    } label: {
                        ZStack {
                            (hovered == "BACK" || progress2 != .clean ? Color.secondary.opacity(0.7) : Color.secondary)
                                .cornerRadius(10)
                                .onHover(perform: { hovering in
                                    hovered = hovering ? "BACK" : nil
                                })
                            Text("Back")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 4)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading, 15)
                    Spacer()
                    Button {
                        if progress2 == .clean {
                            p = 2
                        }
                    } label: {
                        ZStack {
                            (hovered == "CONTINUE" || progress2 != .clean ? Color.accentColor.opacity(0.7) : Color.accentColor)
                                .cornerRadius(10)
                                .onHover(perform: { hovering in
                                    hovered = hovering ? "CONTINUE" : nil
                                })
                            Text("Continue")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 4)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.trailing, 15)
                }
            }.padding(.top, 15)
            Spacer()
            if progress2 == .clean {
                Text(info!.macName)
                    .font(.system(size: 17)).bold()
                HStack(spacing: 1) {
                    Text("Reported by: ")
                    ZStack {
                        if known.contains(Substring(info!.author)) {
                            Rectangle()
                                .foregroundColor(.green)
                                .cornerRadius(10)
                        }
                        HStack(spacing: 1) {
                            Text(info!.author).bold()
                            if known.contains(Substring(info!.author)), #available(OSX 11.0, *) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 10))
                                    .help("This report was written by an trusted member of the patching community.")
                            }
                        }.foregroundColor(known.contains(Substring(info!.author)) ? .white : .primary)
                        .padding(known.contains(Substring(info!.author)) ? 1 : 0)
                        .padding(.horizontal, known.contains(Substring(info!.author)) ? 2 : 0)
                    }.fixedSize()
                    if info!.approved.count > 0 {
                        Text(" (\(info!.approved.count) \(info!.approved.count == 1 ? "person" : "others") approve\(info!.approved.count == 1 ? "s" : ""))")
                    }
                }.font(.system(size: 11))
                Text(info!.details)
                    .padding(5)
                    .padding(.horizontal, 5)
                    .multilineTextAlignment(.center)
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(info!.works, id: \.self) { item in
                            HStack {
                                Rectangle()
                                    .foregroundColor(.green)
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(10)
                                Text(item)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(info!.unknown, id: \.self) { item in
                            HStack {
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(10)
                                Text(item)
                                    .font(.system(size: 11.5))
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(info!.warns, id: \.self) { item in
                            HStack {
                                Rectangle()
                                    .foregroundColor(.red)
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(10)
                                Text(item)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
            } else if progress2 == .noCompat {
                Text("Unable to find the compatability report for your model. Your Mac will probably work assuming that this feature is new and not many people have contributed yet. However, you can still try it and if you do, please contribute your results, it's not that hard and well help more people in the future!")
            } else {
                Text("Verifing Mac")
                    .bold()
                Text("This first step is esentail to how realiable Patched Sur is. This step tries to detect as many problems caused as possible before running into them. This includes FileVault, Fusion Drives and many other problems.")
                    .padding()
                    .multilineTextAlignment(.center)
                VerifierProgressBar(progress2: $progress2, info: $info, problems: $problems, possible: $possible, known: $known)
            }
            Spacer()
        }
    }
}

enum VerifyProgess {
    case downloading
    case verifing
    case issues
    case clean
    case noCompat
    case errored
}

struct VerifierProgressBar: View {
    @State var progress = CGFloat(0)
    @Binding var progress2: VerifyProgess
    @Binding var info: CompatInfo?
    @Binding var problems: ProblemInfo
    @Binding var possible: ProblemInfo?
    @Binding var known: [Substring]
    @State var errorX = "Uh-oh, Something went wrong."
    var body: some View {
        ZStack {
            ProgressBar(value: $progress, length: 200)
            switch progress2 {
            case .downloading:
                Text("Fetching Details...")
                    .foregroundColor(.white)
                    .padding(7)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            var macModel = ""
                            do {
                                macModel = try shellOut(to: "sysctl -n hw.model")
                            } catch {
                                progress2 = VerifyProgess.errored
                                errorX = "Failed to detect Mac Model\n\(error.localizedDescription)"
                                return
                            }
                            progress = CGFloat(0.01)
//                            macModel = "MacBookPro10,2"
                            print("Detected model:" + macModel)
                            print("Downloading model details from: https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/Compatibility/\(macModel.replacingOccurrences(of: ",", with: "%2C")).json")
                            do {
                                info = try CompatInfo(fromURL: URL(string: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/Compatibility/\(macModel.replacingOccurrences(of: ",", with: "%2C")).json")!)
                            } catch {
                                print("Failed to fetch Mac Model compatability report... Assuming it doesn't exist!")
                            }
                            progress = CGFloat(0.1)
                            do {
                                possible = try ProblemInfo.init(fromURL: URL(string: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/ProblemDetection.json")!)
                            } catch {
                                progress2 = VerifyProgess.errored
                                errorX = "Failed to download possible problems.\n\(error.localizedDescription)"
                                return
                            }
                            progress = CGFloat(0.2)
                            if info != nil {
                                do {
                                    known = try String(contentsOf: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/KnownContributors").split(separator: "\n")
                                } catch {
                                    known = ["BenSova"]
                                    print("Failed to find known contibutors, skipping this step.")
                                }
                            }
                            progress = CGFloat(0.25)
                            progress2 = .verifing
                        }
                    }
            case .verifing:
                Text("Verifing Mac...")
                    .foregroundColor(.white)
                    .padding(7)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            try? possible!.forEach { problem in
                                let checkParts = problem.check.split(separator: ";")
                                switch checkParts[0] {
                                case "terminal":
                                    if checkParts.count <= 4 {
                                        switch checkParts[2] {
                                        case "equals":
                                            var output = ""
                                            do {
                                                output = try shellOut(to: "\(checkParts[1])")
                                            } catch let error as ShellOutError {
                                                output = error.output
                                            }
                                            if output == checkParts[3] {
                                                problems.append(problem)
                                            }
                                            progress += CGFloat(0.75) / CGFloat(possible!.count)
                                        default:
                                            errorX = "Unknown compare type for terminal from \"\(problem.title)\""
                                        }
                                    } else {
                                        errorX = "Not enough peices for terminal type from \"\(problem.title)\""
                                    }
                                default:
                                    errorX = "Invalid check type from \"\(problem.title)\"."
                                }
                            }
                            if problems.count > 0 {
                                progress2 = .issues
                            } else {
                                progress2 = info != nil ? .clean : .noCompat
                            }
                        }
                    }
            default:
                Text(errorX)
                    .foregroundColor(.white)
                    .padding(7)
            }
        }.fixedSize(horizontal: false, vertical: true)
        .frame(width: 200)
    }
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
