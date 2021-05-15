//
//  RecoveryPatchView.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/18/21.
//

import VeliaUI

struct RecoveryPatchView: View {
    @State var hovered: String?
    @State var topCompress = false
    @Binding var at: Int
    @State var progress = 0
    @State var showPassPrompt = false
    @State var password = ""
    @State var errorX = ""
    @State var statusText = ""
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: NSLocalizedString("PO-IR-TITLE", comment: "PO-IR-TITLE"), s: NSLocalizedString("PO-IR-SUBTITLE", comment: "PO-IR-SUBTITLE"), c: $topCompress)
                        .alignment(.leading)
                    Spacer()
                    VIButton(id: "BACK", h: $hovered) {
                        Image("BackArrow")
                            .resizable()
                            .frame(width: topCompress ? 10 : 15, height: topCompress ? 10 : 15)
                            .scaleEffect(topCompress ? 1.2 : 1)
                    } onClick: {
                        withAnimation {
                            at = 0
                        }
                    }
                }.padding(.top, 40)
                Spacer(minLength: 0)
                if progress == 0 {
                    Text(.init("DISCLAMIER"))
                        .font(Font.system(size: 15).bold())
                        .transition(.moveAway2)
                    ScrollView {
                        Text(.init("PO-IR-DISCLAIM"))
                            .multilineTextAlignment(.center)
                    }.fixedSize(horizontal: false, vertical: true).padding(.vertical, 5)
                    .transition(.moveAway)
                    VIButton(id: "CONTINUE", h: $hovered) {
                        Text(.init("CONTINUE"))
                        Image("ForwardArrowCircle")
                    } onClick: {
                        let sipStatus = try! call("csrutil status")
                        if sipStatus.contains("Protection status: enable") || sipStatus.contains("Filesystem Protections: enabled") {
                            print("Recovery probably won't work out since SIP is on.")
                            let errorAlert = NSAlert()
                            errorAlert.alertStyle = .warning
                            errorAlert.informativeText = NSLocalizedString("PO-IR-SIP-ON-DESCRIPTION", comment: "PO-IR-SIP-ON-DESCRIPTION")
                            errorAlert.messageText = NSLocalizedString("PO-IR-SIP-ON", comment: "PO-IR-SIP-ON")
                            errorAlert.runModal()
                            return
                        }
                        withAnimation {
                            progress = 1
                        }
                    }.inPad()
                    .transition(.moveAway2)
                } else {
                    Text(.init("PO-IR-PATCHING"))
                        .font(Font.system(size: 15).bold())
                        .transition(.moveAway2)
                    Text(.init("PO-IR-PATCHING-DESCRIPTION"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 1)
                        .multilineTextAlignment(.center)
                        .transition(.moveAway)
                }
                switch progress {
                case 0:
                    EmptyView()
                case 1:
                    VIButton(id: "REQUEST", h: $hovered) {
                        Text(.init("REQUEST-ROOT"))
                    } onClick: {
                        withAnimation {
                            showPassPrompt = true
                        }
                    }.inPad().onAppear {
                        withAnimation(Animation.default.delay(0.25)) {
                            showPassPrompt = true
                        }
                    }.transition(.moveAway2)
                case 2:
                    VIButton(id: "NO", h: .constant("")) {
                        Image("DownloadArrow")
                        Text(.init("PO-IR-DOWNLOAD-RECOVERY"))
                    }.inPad()
                    .btColor(.gray)
                    .transition(.moveAway2)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            downloadRecovery { (errorL) in
                                errorX = errorL
                                withAnimation {
                                    progress = -1
                                }
                            } done: {
                                withAnimation {
                                    progress = 3
                                }
                            }
                        }
                    }
                case 3:
                    VIButton(id: "NO", h: .constant("")) {
                        Image("DownloadArrow")
                        Text(.init("DOWNLOAD-PATCHES"))
                    }.inPad()
                    .btColor(.gray)
                    .transition(.moveAway2)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            kextDownload(size: {_ in}, next: {
                                withAnimation {
                                    progress = 4
                                }
                            }) { (errorL) in
                                errorX = errorL
                                withAnimation {
                                    progress = -1
                                }
                            }
                        }
                    }
                case 4:
                    VStack {
                        VIButton(id: "NO", h: .constant("")) {
                            Image("TriUpCircle")
                            Text(.init("PO-IR-PATCHING"))
                        }.inPad()
                        .btColor(.gray)
                        .transition(.moveAway2)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                installRecovery(password: password) {
                                    statusText = $0
                                } errorX: { (errorL) in
                                    errorX = errorL
                                    withAnimation {
                                        progress = -1
                                    }
                                } done: {
                                    withAnimation {
                                        progress = 5
                                    }
                                }
                            }
                        }
                        Text(statusText)
                            .font(.caption)
                            .lineLimit(2)
                    }
                case 5:
                    VStack {
                        Text(.init("PO-IR-DONE"))
                        VIButton(id: "DONE", h: $hovered) {
                            Image(systemName: "circle.grid.3x3")
                                .font(Font.system(size: 15).weight(.medium))
                            Text(.init("GO-HOME"))
                        } onClick: {
                            withAnimation {
                                at = 0
                            }
                        }.inPad()
                    }.transition(.moveAway2)
                case -1:
                    VIError(errorX)
                default:
                    Text("Umm... I don't know how you did this.")
                        .transition(.moveAway2)
                }
                Spacer(minLength: 0)
            }.padding(.horizontal, 30)
            .padding(.bottom, 15)
            EnterPasswordPrompt(password: $password, show: $showPassPrompt) {
                showPassPrompt = false
                progress = 2
            }
        }
    }
}
