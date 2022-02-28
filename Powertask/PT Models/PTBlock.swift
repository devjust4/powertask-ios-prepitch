//
//  Block.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import Foundation

struct PTBlock: Codable {
    var id: Int?
    var timeStart: Date
    var timeEnd: Date
    var day : Int
    var subject: PTSubject?
}
