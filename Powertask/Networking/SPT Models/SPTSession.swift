//
//  SPTSession.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTSession: Decodable, Encodable {
    var id: Int?
    var quantity: Int?
    var duration: Int?
    var total_time: Int?
    var task_id: Int?
    var student_id: Int?
}
