//
//  Periods.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 3/2/22.
//

import Foundation
struct PTPeriod: Codable {
    var id: Int?
    var name: String
    var startDate: Date
    var endDate: Date
    var subjects: [PTSubject]?
    var blocks: [PTBlock]?
    
    
    init(name: String, startDate: Date, endDate: Date){
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
}
