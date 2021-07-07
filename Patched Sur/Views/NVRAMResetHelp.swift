//
//  NVRAMResetHelp.swift
//  Patched Sur
//
//  Created by Ben Sova on 7/6/21.
//

import SwiftUI
import VeliaUI

struct NVRAMResetHelp: View {
    @State var progress = 0
    @Binding var at: Int
    @State var topCompress = false
    @State var hovered: String?
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                VIHeader(p: NSLocalizedString("PO-NV-BAR-TITLE", comment: "PO-NV-BAR-TITLE"), s: NSLocalizedString("PO-NV-BAR-SUBTITLE", comment: "PO-NV-BAR-SUBTITLE"), c: $topCompress)
                    .alignment(.leading)
                Spacer()
                VIButton(id: "BACK", h: $hovered) {
                    Image(systemName: "chevron.backward.circle")
                        .font(topCompress ? Font.system(size: 11).weight(.bold) : Font.body.weight(.medium))
                    Text(.init("BACK"))
                        .font(topCompress ? Font.system(size: 11).weight(.medium) : Font.body)
                        .padding(.leading, -5)
                } onClick: {
                    withAnimation {
                        at = 0
                    }
                }.inPad()
            }.padding(.top, 40)
            Spacer()
            switch progress {
            case 0:
                VStack {
                    Text(.init("PO-NV-POPUP-TITLE"))
                        .font(Font.system(size: 15).bold())
                    (Text(.init("PO-NV-POPUP-DESCRIPTION")) + Text(.init("PO-NV-POPUP-DESCRIPTION-THREE")))
                        .padding()
                        .multilineTextAlignment(.center)
                    VIButton(id: "GOAHEAD", h: $hovered) {
                        Text(.init("PO-NV-POPUP-START"))
                        Image("ForwardArrowCircle")
                    } onClick: {
                        withAnimation {
                            progress = 1
                        }
                    }.inPad()
                }.transition(.moveAway)
            case 1:
                VStack {
                    Text(.init("PO-NV-CHECK-TITLE"))
                        .font(Font.system(size: 15).bold())
                    Text(.init("PO-NV-CHECK-DESCRIPTION"))
                        .padding()
                        .multilineTextAlignment(.center)
                    VIButton(id: "OPTIONONE", h: $hovered) {
                        Image("CheckCircle")
                        Text(.init("PO-NV-CHECK-ONE"))
                    } onClick: {
                        withAnimation {
                            progress = 2
                        }
                    }.inPad()
                    VIButton(id: "OPTIONTWO", h: $hovered) {
                        Image(systemName: "xmark.circle")
                            .font(Font.system(size: 15).weight(.medium))
                        Text(.init("PO-NV-CHECK-TWO"))
                    } onClick: {
                        withAnimation {
                            progress = 3
                        }
                    }.inPad()
                }.transition(.moveAway)
            case 2:
                VStack {
                    Text(.init("PO-NV-ONE-TITLE"))
                        .font(Font.system(size: 15).bold())
                    Text(.init("PO-NV-ONE-CONTENT"))
                        .padding(.vertical, 7.5)
                        .multilineTextAlignment(.leading)
                    HStack {
                        VIButton(id: "BACKOTHER", h: $hovered) {
                            Image("BackArrowCircle")
                            Text(.init("BACK"))
                        } onClick: {
                            withAnimation {
                                progress = 1
                            }
                        }.inPad()
                            .btColor(.gray).useHoverAccent()
                        VIButton(id: "HOME", h: $hovered) {
                            Image(systemName: "circle.grid.3x3")
                                .font(Font.system(size: 15).weight(.medium))
                            Text(.init("GO-HOME"))
                        } onClick: {
                            withAnimation {
                                at = 0
                            }
                        }.inPad()
                    }
                }.transition(.moveAway)
            case 3:
                VStack {
                    Text(.init("PO-NV-TWO-TITLE"))
                        .font(Font.system(size: 15).bold())
                    Text(.init("PO-NV-TWO-CONTENT"))
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                    HStack {
                        VIButton(id: "BACKOTHER", h: $hovered) {
                            Image("BackArrowCircle")
                            Text(.init("BACK"))
                        } onClick: {
                            withAnimation {
                                progress = 1
                            }
                        }.inPad()
                            .btColor(.gray).useHoverAccent()
                        VIButton(id: "HOME", h: $hovered) {
                            Image(systemName: "circle.grid.3x3")
                                .font(Font.system(size: 15).weight(.medium))
                            Text(.init("GO-HOME"))
                        } onClick: {
                            withAnimation {
                                at = 0
                            }
                        }.inPad()
                    }
                }.transition(.moveAway)
            default:
                Text("Ummmm....")
            }
            Spacer()
        }.padding(.horizontal, 30)
    }
}
