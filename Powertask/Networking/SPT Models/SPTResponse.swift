//
//  SPTResponse.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTResponse: Decodable {
    var tasks: [PTTask]?
    var courses: [PTCourse]?
    var sessions: [PTSession]?
    var events: [String : PTDay]?
    var response: String?
}
