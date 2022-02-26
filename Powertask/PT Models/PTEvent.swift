//
//  Event.swift
//  Powertask
//
//  Created by Daniel Torres on 1/2/22.
//

import Foundation

struct PTEvent: Codable {
    var id: Int?
    var name: String
    var type: EventType.RawValue
    var all_Day: Int
    var notes: String?
    var startDate: Double
    var endDate: Double
    var subject: PTSubject?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case all_Day = "all_day"
        case startDate = "timestamp_start"
        case endDate = "timestamp_end"
        case subject
        case notes
    }
}




enum EventType: String, Comparable, Codable  {
    static func < (lhs: EventType, rhs: EventType) -> Bool {
        switch lhs {
        case .personal, .exam:
            if rhs == .vacation {
                return true
            } else {
                return false
            }
        case .vacation:
            return false
        }
    }
    
    case vacation = "vacation"
    case exam = "exam"
    case personal = "personal"
}
