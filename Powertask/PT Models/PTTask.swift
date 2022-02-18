//
//  UserTask.swift
//  Powertask
//
//  Created by Daniel Torres on 18/1/22.
//
// probando
import Foundation

struct PTTask {
    var classroomId: Int?
    var studentId: Int?
    var id: Int?
    var completed: Bool
    var name: String
    var subject: PTSubject?
    var description: String?
    var mark: Float?
    var handoverDate: Date? {
        didSet {
            serverHandoverDate = handoverDate?.formatToString(using: .serverDate)
        }
    }
    var serverHandoverDate: String?
    var startDate: Date? {
        didSet {
            serverStartDate = startDate?.formatToString(using: .serverDate)
        }
    }
    var serverStartDate: String?
    var subtasks: [UserSubtask]?
}

struct UserSubtask {
    var name: String?
    var done: Bool
    
    init(name: String?, done: Bool) {
        self.name = name
        self.done = done
    }
}
