//
//  SPTEvent.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTEvent: Decodable, Encodable {
    var id: Int?
    var name: String?
    var type: String?
    var all_day: Int?
    var notes: String?
    var date_start: String?
    var date_end: String?
    var time_start: String?
    var time_end: String?
    var student_id: Int?
    var subject_id: Int?
}
