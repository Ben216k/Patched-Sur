//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import SwiftUI

struct AboutMyMac: View {
    let systemVersion: String
    let releaseTrack: String
    var gpu: String
    var model: String
    var cpu: String
    var memory: String
    @Binding var at: Int
    var body: some View {
        ZStack {
            if releaseTrack == "Public Beta" {
                LinearGradient(gradient: .init(colors: [.green, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
            } else if releaseTrack == "Developer" {
                LinearGradient(gradient: .init(colors: [.red, .orange]), startPoint: .bottomLeading, endPoint: .topTrailing)
            } else if releaseTrack == "Release" {
                LinearGradient(gradient: .init(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
            }
            HStack {
                Image(["BigSurReal", "BigSurLake", "BigSurSafari", "BigSurSideShot"].randomElement()!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 145, height: 145)
                    .padding()
                VStack(alignment: .leading, spacing: 2) {
                    Text("macOS ").font(.largeTitle).bold() + Text("Big Sur").font(.largeTitle)
                    Text("Version \(systemVersion) Beta").font(.subheadline)
                    Rectangle().frame(height: 15).opacity(0).fixedSize()
                    Text("Model         ").font(.subheadline).bold() + Text(model)
                    Text("CPU            ").font(.subheadline).bold() + Text(cpu)
                    Text("GPU            ").font(.subheadline).bold() + Text(gpu)
                    Text("Memory     ").bold() + Text(memory) + Text("GB")
                    HStack {
                        Button {
                            at = 0
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.green)
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.blue)
                                }
                                Text("Back to Home")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .padding(.horizontal, 4)
                            }.fixedSize()
                            .cornerRadius(7.5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button {
                            at = 1
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.green)
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.blue)
                                }
                                Text("Software Update")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .padding(.horizontal, 4)
                            }.fixedSize()
                            .cornerRadius(7.5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                }.font(.subheadline)
                .foregroundColor(.white)
            }
        }
    }
}
