//
//  User.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import Foundation

struct PTUser {
    var id: Int?
    var name: String?
    var email: String?
    var imageUrl: String?
    var course: PTCourse?
    var subjects: [PTSubject]?
    var periods: [PTPeriod]?
    var blocks: [PTBlock]?
    var events: [[String : PTDay]]?
    var tasks: [PTTask]?
    var sessions: [PTSession]?
}
