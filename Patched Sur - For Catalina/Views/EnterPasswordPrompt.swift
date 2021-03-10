//
//  EnterPasswordPrompt.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 1/18/21.
//

import VeliaUI

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
                HStack(alignment: .top, spacing: 0) {
                    Image("PSIcon")
                        .padding(.trailing, -15)
                        .padding(.leading, 15)
                        .padding(.top, 10)
                    VStack(alignment: .leading) {
                        Text("Patched Sur would like to make changes.")
                            .bold()
                        Text("Enter your password to allow this.")
                            .foregroundColor(.secondary)
                            .padding(.top, 1)
                            .padding(.bottom, 12)
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack {
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .frame(width: 80)
                                        .foregroundColor(.clear)
                                        .fixedSize()
                                    Text("User Name:")
                                }
                                TextField("Username", text: .constant("bensova"))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            HStack {
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .frame(width: 80)
                                        .foregroundColor(.clear)
                                        .fixedSize()
                                    Text("Password:")
                                }
                                SecureField("Password", text: .constant("password"))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }.padding(.bottom, 12)
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                
                            }
                            Button("Continue") {
                                
                            }
                        }
                    }.padding()
                    .padding(.horizontal, 10)
                }
            }
            .frame(width: 425, height: 200)
            .cornerRadius(10)
        }
    }
}
