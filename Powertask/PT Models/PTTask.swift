//
//  UserTask.swift
//  Powertask
//
//  Created by Daniel Torres on 18/1/22.
//
// probando
import Foundation
import UIKit

struct PTTask: Codable {
    var id: Int?
    var googleId: Int?
    var name: String
    var startDate: Date?
    {
        didSet {
            serverStartDate = startDate?.formatToString(using: .serverDate)
        }
    }
    var handoverDate: Date?
    {
        didSet {
            serverHandoverDate = handoverDate?.formatToString(using: .serverDate)
        }
    }
    var mark: Float?
    var description: String?
    var completed: Bool
    var subject: PTSubject?
    var studentId: Int?
    var subtasks: [PTSubtask]?
    
    var serverHandoverDate: String?
    var serverStartDate: String?
}

enum CodingKeys: String, CodingKey {
    case id
    case googleId = "google_id"
    case name
    case startDate = "date_start"
    case endDate = "date_handover"
    case mark
    case description
    case completed
    case subject
    case studendId = "student_id"
    case subtasks
}
