//
//  SPTResponse.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTResponse: Decodable {
    var tasks: [SPTTask]?
    var courses: [SPTCourse]?
    var sessions: [SPTSession]?
    var events: [String : SPTDay]?
    var response: String?
}
