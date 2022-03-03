//
//  SPTResponse.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTResponse: Decodable {
    var response: String?
    var id: Int?
    var token: String?
    var tasks: [PTTask]?
    var courses: [PTCourse]?
    var sessions: [PTSession]?
    var events: [String : PTEvent]?
    var subjects: [PTSubject]?
    var blocks: [PTBlock]?
}
