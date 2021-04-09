//
//  UpdateChooser.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/7/21.
//

import VeliaUI
import Files

struct UpdateChooser: View {
    @Binding var p: Int
    @State var fetchedInstallers = nil as InstallAssistants?
    @State var publicInstallers = nil as InstallAssistants?
    @Binding var installInfo: InstallAssistant?
    @Binding var track: ReleaseTrack
    @State var current = nil as InstallAssistant?
    @State var errorL = nil as String?
    @State var buttonBG = Color.red
    @State var hovered = nil as String?
    @Binding var useCurrent: Bool
    @Binding var package: String
    @State var selfV = ""
    
    var body: some View {
        HStack(spacing: 15) {
            VIHeader(p: "Update Chooser", s: "v\(AppInfo.version) (\(AppInfo.build))", c: .constant(true))
                .alignment(.leading)
            Spacer()
            VIButton(id: "BACK", h: $hovered) {
                Image("BackArrow")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .scaleEffect(1.2)
            } onClick: {
                withAnimation {
                    p = 2
                }
            }
            VIButton(id: "BROWSE", h: $hovered) {
                Image("Package")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .scaleEffect(1.2)
            } onClick: {
                withAnimation {
                    p = 2
                }
            }
        }.padding(.top, 40)
        
        // MARK: Content
        
        if let errorL = errorL {
            Spacer(minLength: 0)
            Text("An error occurred while fetching available updates.")
            VIError(errorL)
            Spacer(minLength: 0)
        } else if fetchedInstallers == nil {
            Spacer(minLength: 0)
            VIButton(id: "SOMETHING", h: .constant("12")) {
                Image("DownloadArrow")
                Text("Fetching Installers")
            }.inPad()
            .btColor(.gray)
            .onAppear {
                DispatchQueue(label: "FetchInstallers").async {
                    selfV = (try? call("sw_vers -productVersion")) ?? "11.2.3"
                    fetchInstallerList(track: track) {
                        fetchedInstallers = $0
                    } current: {
                        current = $0
                    } errorL: {
                        errorL = $0
                    }
                }
            }
            Spacer(minLength: 0)
        } else {
            ScrollView {
                if let current = current {
                    Text("This version of macOS is already downloaded:")
                    UpdateSelectCell(installer: current, delete: {}, selfV: selfV)
                }
                if let fetched = fetchedInstallers {
                    Text("You can download these versions of macOS:")
                    ForEach(fetched, id: \.buildNumber) { installer in
                        UpdateSelectCell(installer: installer, delete: nil, selfV: selfV)
                    }
                }
                Text("")
                    .padding(.bottom)
            }
        }
    }
}

struct UpdateSelectCell: View {
    let installer: InstallAssistant
    let delete: (() -> ())?
    @State var hovered: String?
    let selfV: String
    
    var body: some View {
        HStack {
            ZStack {
                if convertVersionBinary(installer.version) >= convertVersionBinary(selfV) {
                    RadialGradient(gradient: Gradient(colors: installer.version.contains("Beta") || installer.version.contains("RC") ? [Color.purple.opacity(0.3), Color.purple] : [Color("Accent").opacity(0.3), Color("Accent")]), center: .center, startRadius: 1, endRadius: 40)
                        .cornerRadius(20)
                } else {
                    RadialGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray]), center: .center, startRadius: 1, endRadius: 40)
                        .cornerRadius(20)
                }
                Text(installer.version.contains("Beta") || installer.version.contains("RC") ? "B" : "R")
                    .font(.title2)
                    .foregroundColor(.white)
            }.frame(width: 40, height: 40)
            .offset(x: 0, y: 3)
            VStack(alignment: .leading) {
                Text("macOS \(installer.version)")
                    .font(Font.title3.bold())
                Text("Build \(installer.buildNumber) - Released \(installer.date)")
            }
            Spacer()
            if convertVersionBinary(installer.version) >= convertVersionBinary(selfV) {
                VIButton(id: "UPDDATE\(installer.buildNumber)", h: $hovered) {
                    Image("UpdateCircle")
                    Text("Update")
                }.inPad()
                if delete == nil {
                    VIButton(id: "DOWNLOAD\(installer.buildNumber)", h: $hovered) {
                        Image("DownloadArrow")
                    }.btColor(Color.gray).useHoverAccent()
                    .help("You can also download the InstallAssistant.pkg if you want.")
                }
            } else {
                VIButton(id: "UPDDATE\(installer.buildNumber)", h: $hovered) {
                    Image("DownloadArrow")
                    Text("Download")
                } onClick: {
                    NSWorkspace.shared.open(URL(string: installer.url)!)
                }.inPad()
                .btColor(.gray).useHoverAccent()
                .help("You cannot update to an older version of macOS, but you may download this installer if you want.")
            }
            if delete != nil {
                VIButton(id: "DELETEC", h: $hovered) {
                    Image("ThisImageIsTrash")
                }.btColor(.red)
            }
        }
    }
}

func mergeNoDuplicate(a ar: [InstallAssistant], b: [InstallAssistant]) -> [InstallAssistant] {
    var a = ar
    let aV = a.map { $0.version }
    a.append(contentsOf: b.filter { !(aV.contains($0.version)) })
    return a
}

func fetchInstallerList(track: ReleaseTrack, fetchedInstallers: (InstallAssistants) -> (), current: (InstallAssistant) -> (), errorL: @escaping (String) -> ()) {
    print("Checking for pre-downloaded installer...")
    if (try? call("[[ -e ~/.patched-sur/InstallAssistant.pkg ]]")) != nil && ((try? call("[[ -e ~/.patched-sur/InstallInfo.txt ]]")) != nil) {
        print("Verifying pre-downloaded installer...")
        var alertX: Alert?
        guard let installerPath = (try? File(path: "~/.patched-sur/InstallAssistant.pkg"))?.path else { print("Unable to pull installer path"); return }
        if verifyInstaller(alert: &alertX, path: installerPath), let contents = try? File(path: "~/.patched-sur/InstallInfo.txt").readAsString() {
            print("Phrasing installer data...")
            guard let baseInfo = try? InstallAssistant(contents) else { return }
            current(InstallAssistant(url: installerPath, date: baseInfo.date, buildNumber: baseInfo.buildNumber, version: baseInfo.version, minVersion: 0, orderNumber: 0, notes: nil))
        }
    }
    let thingV = fetchInstallers(errorX: errorL, track: track)
    fetchedInstallers(thingV)
    if track != .release {
        let publicV = fetchInstallers(errorX: {_ in}, track: .release)
        fetchedInstallers(mergeNoDuplicate(a: thingV, b: publicV))
    }
}

func convertVersionBinary(_ version: String) -> Int {
    let vSections = version.split(separator: " ")
    let vParts = vSections[0].split(separator: ".")
    if vParts.count == 0 {
        return 114
    } else if vParts.count == 1 {
        return (Int(String(vParts[0]))! * 100)
    } else if vParts.count == 2 {
        return (Int(String(vParts[0]))! * 100) + (Int(String(vParts[1]))! * 10)
    } else if vParts.count == 3 {
        return (Int(String(vParts[0]))! * 100) + (Int(String(vParts[1]))! * 10) + (Int(String(vParts[2]))! * 1)
    } else {
        return 114
    }
}
