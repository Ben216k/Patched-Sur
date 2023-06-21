//
//  InstallAssistants.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import Foundation

struct InstallAssistant: Codable {
    let url: String
    let date, buildNumber, version: String
    let minVersion, orderNumber: Int
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case url = "URL"
        case date = "Date"
        case buildNumber = "BuildNumber"
        case version = "Version"
        case minVersion = "MinVersion"
        case orderNumber = "OrderNumber"
        case notes = "Notes"
    }
}

extension InstallAssistant {
    var localizedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateObject = dateFormatter.date(from: date) ?? Date(timeIntervalSinceNow: -99999)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.timeStyle = .none
        newDateFormatter.dateStyle = .medium
        newDateFormatter.locale = Locale.current
        newDateFormatter.doesRelativeDateFormatting = true
        
        return newDateFormatter.string(from: formattedDateObject)
    }
}
