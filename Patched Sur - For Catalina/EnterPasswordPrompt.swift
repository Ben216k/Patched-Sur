//
//  EnterPasswordPrompt.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 1/18/21.
//

import SwiftUI

struct EnterPasswordPrompt: View {
    @Binding var password: String
    @Binding var show: Bool
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.5)
            ZStack {
                Rectangle()
                    .foregroundColor(.init(NSColor.windowBackgroundColor))
                VStack {
                    Text("Patched Sur")
                        .bold()
                    Text("Please enter your administartor password.")
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                        .padding(.bottom, 12)
                    VStack(spacing: 8) {
                        HStack {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: 65)
                                    .foregroundColor(.clear)
                                    .fixedSize()
                                Text("Username")
                            }
                            TextField("Username", text: .constant("bensova"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: 65)
                                    .foregroundColor(.clear)
                                    .fixedSize()
                                Text("Password")
                            }
                            SecureField("Password", text: .constant("password"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }.padding(.bottom, 12)
                    HStack {
                        Button("Cancel") {
                            
                        }
                        Button("Continue") {
                            
                        }
                    }
                }.padding()
                .padding(.horizontal, 10)
            }
            .frame(width: 355, height: 200)
            .cornerRadius(10)
        }
    }
}
