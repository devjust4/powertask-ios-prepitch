//
//  Event.swift
//  Powertask
//
//  Created by Daniel Torres on 1/2/22.
//

import Foundation

struct PTEvent {
    var id: Int?
    var name: String
    var type: EventType
    var allDay: Bool?
    var startDate: Date
    var endDate: Date?
    var subject: Subject?
    var notes: String?
    
//    init(name: String, type: EventType, startDate: Date, endDate: Date) {
//        self.name = name
//        self.type = type
//        self.startDate = startDate
//        self.endDate = endDate
//    }
//    
//    init(name: String, type: EventType, startDate: Date, subject: Subject) {
//        self.name = name
//        self.type = type
//        self.startDate = startDate
//        self.subject = subject
//    }
    
}

enum EventType: String, Comparable  {
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
    
    case vacation = "festivo"
    case exam = "examen"
    case personal = "evento"
}
