//
//  UserTask.swift
//  Powertask
//
//  Created by Daniel Torres on 18/1/22.
//
// probando
import Foundation

struct UserTask {
    var classroomId: Int?
    var studentId: Int?
    var id: Int?
    var completed: Bool
    var name: String
    var subject: Subject?
    var description: String?
    var mark: Float?
    var handoverDate: Date?
    var startDate: Date?
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
