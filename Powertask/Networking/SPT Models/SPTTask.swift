//
//  SPTTask.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTTask: Decodable, Encodable {
    var id: Int?
    var name: String?
    var date_completed: String?
    var date_handover: String?
    var mark: Int?
    var description: String?
    var completed: Int?
    var subject: PTSubject?
    var student_id: Int?
    var subtasks: [SPTSubtask]?
}

struct SPTSubtask: Decodable, Encodable {
    var id: Int?
    var name: String?
    var description: String?
    var completed: Int?
}
