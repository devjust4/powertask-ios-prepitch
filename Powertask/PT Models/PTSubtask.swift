//
//  PTSubtask.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct PTSubtask: Codable {
    var name: String?
    var done: Bool
    
    init(name: String?, done: Bool) {
        self.name = name
        self.done = done
    }
}
