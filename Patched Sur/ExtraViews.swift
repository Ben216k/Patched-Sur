//
//  ExtraViews.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/30/20.
//

import SwiftUI

struct DoubleButtonView: View {
    var first: () -> ()
    var second: () -> ()
    var text: String
    @State var buttonBG = Color.accentColor
    @State var buttonBG2 = Color.secondary
    var body: some View {
        HStack {
            Button {
                first()
            } label: {
                ZStack {
                    buttonBG2
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG2 = hovering ? Color.secondary.opacity(0.7) : Color.secondary
                        })
                    Text("Back")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 10)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            Button {
                second()
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.blue.opacity(0.7) : Color.blue
                        })
                    Text(text)
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 10)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }.fixedSize()
    }
}

struct RunActionsDisplayView: View {
    var action: () -> ()
    var text: String
    var body: some View {
        ZStack {
            Color.secondary
                .cornerRadius(10)
                .frame(minWidth: 200, maxWidth: 450)
            Text(text)
                .foregroundColor(.white)
                .lineLimit(4)
                .padding(6)
                .padding(.horizontal, 4)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        action()
                    }
                }
        }.fixedSize()
    }
}

struct EnterPasswordButton: View {
    @Binding var password: String
    @State var buttonBG = Color.accentColor
    var onDone: () -> ()
    @State var invalidPassword = false
    var body: some View {
        HStack {
            ZStack {
                Color.secondary
                    .cornerRadius(10)
                    .frame(width: 300)
                    .opacity(0.7)
                SecureField("Enter password to install...", text: $password)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(6)
                    .padding(.horizontal, 4)
                    .disabled(false)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .colorScheme(.dark)
            }
            Button {
                if password != "" {
                    do {
                        try shellOut(to: "echo \"\(password)\" | sudo -S echo Hi")
                        onDone()
                    } catch {
                        invalidPassword = true
                        password = ""
                    }
                }
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            if !(password == "") {
                                if invalidPassword {
                                    buttonBG = hovering ? Color.red.opacity(0.7) : Color.red
                                } else {
                                    buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                                }
                            }
                        })
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 10)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 10)
            .opacity(password == "" ? 0.4 : 1)
        }.fixedSize()
    }
}
