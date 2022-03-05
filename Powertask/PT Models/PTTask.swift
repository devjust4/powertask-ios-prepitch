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
    var handoverDate: Date?
    var mark: Float?
    var description: String?
    var completed: Int
    var subject: PTSubject?
    var studentId: Int?
    var subtasks: [PTSubtask]?
}

enum CodingKeys: String, CodingKey {
    case id
    case googleId = "google_id"
    case name
    case serverStartDate = "date_start"
    case serverHandoverDate = "date_handover"
    case mark
    case description
    case completed
    case subject
    case studendId = "student_id"
    case subtasks
}
