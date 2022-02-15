//
//  User.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import Foundation

struct PowerTaskUser {
    var id: Int?
    var name: String?
    var email: String?
    var imageUrl: String?
    var course: Course?
    var subjects: [Subject]?
    var periods: [Period]?
    var blocks: [Block]?
    var events: [[String : Day]]?
    var tasks: [UserTask]?
    var sessions: [Session]?
}
