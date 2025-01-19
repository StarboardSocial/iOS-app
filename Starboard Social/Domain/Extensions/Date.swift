//
//  Date.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 24/12/2024.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    static func fromString(_ string: String) -> Date? {
        return ISO8601DateFormatter().date(from: string)
    }
}
