//
//  Session.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import Foundation


struct PTSession: Codable {
    var id: Int?
    var quantity: Int? // que es quantity
    var duration: Int?
    var task: PTTask?
    
}
