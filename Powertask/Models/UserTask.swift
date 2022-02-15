//
//  UserTask.swift
//  Powertask
//
//  Created by Daniel Torres on 18/1/22.
//
// probando
import Foundation

class UserTask {
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
    
    init(completed: Bool, name: String, subject: Subject, description: String, mark: Float, startDate: Date) {
        self.completed = completed
        self.name = name
        self.subject = subject
        self.description = description
        self.mark = mark
        self.startDate = startDate
    }
    
    init(completed: Bool, name: String, subject: Subject, description: String, mark: Float, startDate: Date, subtasks: [UserSubtask]) {
        self.completed = completed
        self.name = name
        self.subject = subject
        self.description = description
        self.mark = mark
        self.startDate = startDate
        self.subtasks = subtasks
    }
}

class UserSubtask {
    var name: String?
    var done: Bool
    
    init(name: String?, done: Bool) {
        self.name = name
        self.done = done
    }
}
