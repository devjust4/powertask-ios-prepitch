//
//  SPTPeriod.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTPeriod: Decodable, Encodable {
    var id: Int?
    var name: String?
    var date_start: String?
    var date_end: String?
    var student_id: Int?
}
