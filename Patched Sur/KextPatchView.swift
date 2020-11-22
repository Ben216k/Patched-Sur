//
//  KextPatchView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/29/20.
//

import SwiftUI

struct KextPatchView: View {
    @Binding var at: Int
    var body: AnyView {
        AnyView(VStack {
            TopKextsView()
            ButtonsView(at: $at)
        }.navigationTitle("Patched Sur"))
    }
}

struct ButtonsView: View {
    @Binding var at: Int
    @State var p = 0
    @State var password = ""
    @State var buttonBG = Color.blue
    @State var errorMessage = ""
    @State var installerName = ""
    var body: some View {
        switch p {
        case 0:
            DoubleButtonView(first: {
                at = 0
            }, second: {
                p = 1
            }, text: "Continue")
        case 1:
            RunActionsDisplayView(action: {
                do {
                    installerName = (try? shellOut(to: "[[ -d '/Volumes/Install macOS Big Sur Beta' ]]")) != nil ? "Install macOS Big Sur Beta" : "Install macOS Big Sur"
                    try shellOut(to: "[[ -d '/Volumes/\(installerName)/patch-kexts.sh' ]]")
                    p = 2
                } catch {
                    p = -1
                }
            }, text: "Detecting Volumes")
        case -1:
            VStack {
                DoubleButtonView(first: {
                    at = 0
                }, second: {
                    p = 1
                }, text: "Plug in USB Installer and Try Again")
                Button {
                    p = 2
                } label: {
                    Text("Force Skip Check")
                        .font(.caption)
                }.buttonStyle(BorderlessButtonStyle())
            }
        case 2:
            EnterPasswordButton(password: $password) {
                p = 3
            }
        case 3:
            RunActionsDisplayView(action: {
                do {
                    try shellOut(to: "echo \(password.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")) | sudo -S '/Volumes/\(installerName)/patch-kexts.sh'")
                    p = 4
                } catch {
                    errorMessage = error.localizedDescription
                    p = -2
                }
            }, text: "Patching Kexts...")
        case -2:
            VStack {
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(errorMessage, forType: .string)
                } label: {
                    ZStack {
                        buttonBG
                            .cornerRadius(10)
                            .frame(minWidth: 200, maxWidth: 450)
                            .onHover(perform: { hovering in
                                buttonBG = hovering ? Color.red.opacity(0.7) : .red
                            })
                            .onAppear(perform: {
                                if buttonBG != .red && buttonBG != Color.red.opacity(0.7) {
                                    buttonBG = .red
                                }
                            })
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .lineLimit(6)
                            .padding(6)
                            .padding(.horizontal, 4)
                    }
                }.buttonStyle(BorderlessButtonStyle())
                .fixedSize()
                Text("Click to Copy")
                    .font(.caption)
            }
        case 4:
            Button {
                DispatchQueue.global(qos: .background).async {
                    do {
                        try shellOut(to: "echo \(password.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")) | sudo -S sudo reboot")
                    } catch {
                        print("Error, but they can do it themselves.")
                    }
                }
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    Text("Restart to Finish")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 50)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        default:
            Text("Something went wrong. This number is out of range.\nError 0x\(p)")
        }
    }
}

struct TopKextsView: View {
    var body: some View {
        Text("Patch Kexts").bold()
        Text("Patching your kexts gets you Wifi, USB, and many other things working on your Big Sur installation. Without these kexts, your Mac would not be at its full potential on Big Sur, and several things would not work. Makes sense right?")
            .padding()
            .multilineTextAlignment(.center)
    }
}
