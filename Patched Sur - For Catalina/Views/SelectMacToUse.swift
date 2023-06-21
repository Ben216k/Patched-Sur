//
//  SelectMacToUse.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import VeliaUI

struct SelectMacView: View {
    @State var hovered: String?
    @Binding var problemInfo: ProblemInfo?
    @Binding var selectedMac: String?
    
    var body: some View {
        VStack {
            Text("Advanced: Select a Mac")
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 10)
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text("This Mac").font(.system(size: 13).bold())
                        Text(problemInfo == nil ? "Continue using this Mac" : "The earlier issue detected prevents use of this Mac.").font(.caption)
                    }
                    Spacer()
                    VIButton(id: "this", h: problemInfo == nil ? (selectedMac == "this" ? .constant("this") : $hovered) : .constant("that")) {
                        Text(problemInfo == nil ? (selectedMac == "this" ? "Selected" : "Select") : "Cannot Select")
                    } onClick: {
                        if problemInfo == nil { withAnimation { selectedMac = "this" } }
                    }.inPad().btColor(problemInfo == nil ? .accentColor : .secondary)
                        .disabled(true)
                }.padding(.horizontal)
                Divider().padding(.horizontal)
                ForEach(supportedMacs, id: \.short) { mac in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(mac.name).font(.system(size: 13).bold())
                            Text(mac.short).font(.caption)
                        }
                        Spacer()
                        VIButton(id: mac.short, h: (selectedMac == mac.short ? .constant(mac.short) : $hovered)) {
                            Text(selectedMac == mac.short ? "Selected" : "Select")
                        } onClick: {
                            withAnimation { selectedMac = mac.short }
                        }.inPad()
                    }
                    Divider()
                }.padding(.horizontal)
                Text("If you do not see your Mac, Patched Sur does not support it. The installer USB that will be created will work for all Macs, regardless of selected Mac here.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
            }
        }
    }
}
