//
//  EnterPasswordPrompt.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 1/18/21.
//

import VeliaUI
import Darwin

struct EnterPasswordPrompt: View {
    @Binding var password: String
    @Binding var show: Bool
    let onSuccess: () -> ()
    var onCancel: (() -> ())?
    @State var xOffset = 0 as CGFloat
    
    var body: some View {
        if show {
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.5)
                ZStack {
                    Rectangle()
                        .foregroundColor(.init(NSColor.windowBackgroundColor))
                    HStack(alignment: .top, spacing: 0) {
                        Image("PSIcon")
                            .padding(.trailing, -15)
                            .padding(.leading, 15)
                            .padding(.top, 10)
                        VStack(alignment: .leading) {
                            Text(.init("B-ENTER-PASS-CHANGES"))
                                .bold()
                            Text(.init("B-ENTER-PASS-ALLOW"))
                                .foregroundColor(.secondary)
                                .padding(.top, 1)
                                .padding(.bottom, 12)
                            HStack(alignment: .top) {
                                VStack(alignment: .trailing, spacing: 8) {
                                    ZStack {
                                        TextField("", text: .constant(""))
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width: 1)
                                            .opacity(0)
                                        Text(.init("B-EP-USERNAME"))
                                    }
                                    ZStack {
                                        TextField("", text: .constant(""))
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width: 1)
                                            .opacity(0)
                                        Text(.init("B-EP-PASSWORD"))
                                    }
                                }
                                VStack(alignment: .trailing, spacing: 8) {
                                    TextField("", text: .constant(NSFullUserName()))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    SecureField(NSLocalizedString("B-EP-PASSWORD-PH", comment: "B-EP-PASSWORD-PH"), text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .onAppear {
                                            if getuid().description == "0" {
                                                onSuccess()
                                                withAnimation {
                                                    show = false
                                                }
                                                return
                                            }
                                            if (try? call("echo Correct Password", p: password)) != nil {
                                                onSuccess()
                                                withAnimation {
                                                    show = false
                                                }
                                            } else {
                                                password = ""
                                            }
                                        }
    //                                HStack {
    //                                    ZStack(alignment: .trailing) {
    //                                        Rectangle()
    //                                            .frame(width: 85)
    //                                            .foregroundColor(.clear)
    //                                            .fixedSize()
    //                                        Text(.init("B-EP-USERNAME"))
    //                                    }
    ////                                    TextField("Username", text: .constant((try! call("whoami"))))
    //                                    TextField("", text: .constant(NSFullUserName()))
    //                                        .textFieldStyle(RoundedBorderTextFieldStyle())
    //                                }
    //                                HStack {
    //                                    ZStack(alignment: .trailing) {
    //                                        Rectangle()
    //                                            .frame(width: 85)
    //                                            .foregroundColor(.clear)
    //                                            .fixedSize()
    //                                        Text(.init("B-EP-PASSWORD"))
    //                                    }
    //                                    SecureField(NSLocalizedString("B-EP-PASSWORD-PH", comment: "B-EP-PASSWORD-PH"), text: $password)
    //                                        .textFieldStyle(RoundedBorderTextFieldStyle())
    //                                        .onAppear {
    //                                            if (try? call("echo Correct Password", p: password)) != nil {
    //                                                onSuccess()
    //                                                withAnimation {
    //                                                    show = false
    //                                                }
    //                                            } else {
    //                                                password = ""
    //                                            }
    //                                        }
    //                                }
                                }.padding(.bottom, 12)
                            }
                            HStack {
                                Spacer()
                                NativeButton(NSLocalizedString("CANCEL", comment: "Cancel"), keyEquivalent: .none) {
                                    (onCancel ?? {})()
                                    password = ""
                                    withAnimation {
                                        show = false
                                    }
                                }
                                NativeButton(NSLocalizedString("CONTINUE", comment: "CONTINUE"), keyEquivalent: .return) {
                                    if (try? call("echo Correct Password", p: password)) != nil {
                                        onSuccess()
                                        withAnimation {
                                            show = false
                                        }
                                    } else {
                                        password = ""
                                    }
                                }
                            }
                        }.padding()
                        .padding(.horizontal, 10)
                    }
                }
                .frame(width: 425, height: 200)
                .cornerRadius(10)
                .offset(x: xOffset)
            }
        }
    }
}

private var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

protocol ControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

private final class ActionTrampoline<T>: NSObject {
    let action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc
    func action(sender: AnyObject) {
        action(sender as! T)
    }
}

extension ControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension NSControl: ControlActionClosureProtocol {}

@available(macOS 10.15, *)
struct NativeButton: NSViewRepresentable {
    enum KeyEquivalent: String {
        case escape = "\u{1b}"
        case `return` = "\r"
    }

    var title: String?
    var attributedTitle: NSAttributedString?
    var keyEquivalent: KeyEquivalent?
    let action: () -> Void

    init(
        _ title: String,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    init(
        _ attributedTitle: NSAttributedString,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.attributedTitle = attributedTitle
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }

    func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Self>) {
        if attributedTitle == nil {
            nsView.title = title ?? ""
        }

        if title == nil {
            nsView.attributedTitle = attributedTitle ?? NSAttributedString(string: "")
        }

        nsView.keyEquivalent = keyEquivalent?.rawValue ?? ""

        nsView.onAction { _ in
            self.action()
        }
    }
}
