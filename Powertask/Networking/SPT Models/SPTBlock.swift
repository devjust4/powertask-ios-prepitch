//
//  SPTBlock.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTBlock: Decodable, Encodable {
    var id: Int?
    var time_start: String?
    var time_end: String?
    var day: Int?
    var student_id: Int?
    var subject_id: Int?
}
