//
//  Block.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import Foundation

struct PTBlock: Codable {
    var timeStart: Date
    var timeEnd: Date
    var day : Int
    var subject: PTSubject
    
    enum CodingKeys: String, CodingKey {
        case day, subject
        case timeStart = "time_start"
        case timeEnd = "time_end"
    }
}

struct PTSendableBlock: Codable {
    var timeStart: Double
    var timeEnd: Double
    var subjectID: Int
    
    init(timeStart: Double, timeEnd: Double, subjectID: Int) {
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.subjectID = subjectID
    }
}
