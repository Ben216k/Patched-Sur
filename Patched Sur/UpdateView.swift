//
//  UpdateView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/24/20.
//

import SwiftUI
import Files

struct UpdateView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var at: Int
    @State var progress = 0
    @State var installers = []
    @State var track = ReleaseTrack.release
    @State var latestPatch = nil as PatchedVersion?
    @State var skipAppCheck = false
    var body: some View {
        ZStack {
            if progress == 0 {
                VStack {
                    Text("Software Update")
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(25)
            }
            switch progress {
            case 0:
                VStack {
                    Text("Checking For Updates...")
                        .font(.title2)
                        .fontWeight(.semibold)
                    ProgressView()
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.horizontal)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    if !skipAppCheck, let patchedVersions = try? PatchedVersions(fromURL: "https://api.github.com/repos/BenSova/Patched-Sur/releases").filter({ !$0.prerelease }) {
                                        if patchedVersions[0].tagName != "v\(AppInfo.version)" {
                                            latestPatch = patchedVersions[0]
                                            progress = 1
                                        }
                                    }
                                    if let trackFile = try? File(path: "~/.patched-sur/track.txt").readAsString() {
                                        track = ReleaseTrack(rawValue: trackFile) ?? .release
                                    }
                                    var allInstallers = try InstallAssistants(fromURL:  URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : (track == .publicbeta ? "Public" : "Release")).json")!)
                                    allInstallers = allInstallers.filter { $0.minVersion <= AppInfo.build }
                                } catch {
                                    print("\n==========================================\n")
                                    print("Failed to fetch installer list.")
                                    print(error.localizedDescription)
                                    print("\n==========================================\n")
                                }
                            }
                        }
                }
                .fixedSize()
            case 1:
                UpdateAppView(latest: latestPatch!, p: $progress, skipCheck: $skipAppCheck)
            case -1:
                Text("Hi You! You shouldn't really be seeing this, but here you are!")
                    .onAppear {
                        progress = 0
                        at = 0
                    }
            default:
                VStack {
                    Text("Uh-oh! Something went wrong going through the software update steps.\nError 1x\(progress)")
                    Button("Go Back Home") {
                        at = 0
                    }
                }
            }
        }
        .navigationTitle("Patched Sur")
    }
}

enum ReleaseTrack: String, CustomStringConvertible {
    case release = "Release"
    case publicbeta = "Public Beta"
    case developer = "Developer"
    
    var description: String { rawValue }
}
