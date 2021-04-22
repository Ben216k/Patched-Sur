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
                    VIHeader(p: "Install Recovery", s: "Kind of Helpful", c: $topCompress)
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
                    Text("DISCLAIMER")
                        .font(Font.system(size: 15).bold())
                        .transition(.moveAway2)
                    Text("This IS NOT something that should be 100% relied on. This is mostly just a \"here, have it this is the best you can get for now.\" I have tried to make a dream recovery mode, but that has not worked out, mostly because the firmware on your Mac ignores files that appear to exist for no reason what so ever. If those files weren't ignored, I wouldn't have to make this message. You can however, do the following with recovery: Manage NVRAM values (like the SIP status and boot-args), use Disk Utility, browse the web (I guess?), and unpatch/patch kexts (and probably some other things).\nMy suggestion is to make an installer usb and hold onto it.\nYou cannot reinstall macOS with this.")
                        .padding(.vertical, 10)
                        .multilineTextAlignment(.center)
                        .transition(.moveAway)
                    VIButton(id: "CONTINUE", h: $hovered) {
                        Text("Continue")
                        Image("ForwardArrowCircle")
                    } onClick: {
                        let sipStatus = try! call("csrutil status")
                        if sipStatus.contains("Protection status: enable") || sipStatus.contains("Filesystem Protections: enabled") {
                            print("Recovery probably won't work out since SIP is on.")
                            let errorAlert = NSAlert()
                            errorAlert.alertStyle = .warning
                            errorAlert.informativeText = "The recovery patch cannot be installed with SIP on because of the filesystem protections. Now it might seem that the only way to turn off SIP is with recovery mode but there are other ways.\n\nIf you still have the installer USB, you might be able to boot into the EFI Boot on it. If that doesn't work or you can't do that, boot into internet recovery mode (CMD-OPTION-R on boot) and you can do it from there."
                            errorAlert.messageText = "SIP is On"
                            errorAlert.runModal()
                            return
                        }
                        withAnimation {
                            progress = 1
                        }
                    }.inPad()
                    .transition(.moveAway2)
                } else {
                    Text("Patching Recovery")
                        .font(Font.system(size: 15).bold())
                        .transition(.moveAway2)
                    Text("macOS Recovery Mode is now being patched onto your Mac. This process has two steps, first is two download the required files, and second is to install them. It's super simple, and doesn't take too long. Once this is done, macOS recovery will be unlocked. Note that if you have multiple partitions, your startup disk's recovery will be (most likely) preferred and will boot instead of the other installed recoveries.")
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
                        Text("Request Root Permissions")
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
                        Text("Downloading Recovery")
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
                        Text("Downloading Patches")
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
                            Text("Patching Recovery")
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
                        Text("Done Patching Recovery!")
                        VIButton(id: "DONE", h: $hovered) {
                            Image(systemName: "circle.grid.3x3")
                                .font(Font.system(size: 15).weight(.medium))
                            Text("Go Home")
                        } onClick: {
                            at = 0
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
