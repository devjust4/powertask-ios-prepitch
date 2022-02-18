//
//  SPTDay.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation

struct SPTDay: Decodable, Encodable {
    var vacation: [SPTEvent]
    var exam: [SPTEvent]
    var personal: [SPTEvent]
}
