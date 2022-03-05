//
//  User.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import Foundation
import GoogleSignIn

class PTUser: Codable {
    static let shared = PTUser()
    private init() {}
    
    var id: Int?
    var new: Bool?
    var name: String?
    var email: String?
    var imageUrl: String?
    var apiToken: String?
    var tasks: [PTTask]?
    var subjects: [PTSubject]?
    var periods: [PTPeriod]?
    var sessions: [PTSession]?
    var events: [String : PTEvent]?
    var blocks: [PTBlock]?
    
    func savePTUser(){
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.set(data, forKey: "user")
        }
    }
    
    func loadPTUser(){
        guard let userData = UserDefaults.standard.object(forKey: "user") as? Data else { return }
        let decoder = JSONDecoder()
        if let user = try? decoder.decode(PTUser.self, from: userData) {
            self.id = user.id
            self.name = user.name
            self.email = user.email
            self.imageUrl = user.imageUrl
            self.subjects = user.subjects
            self.periods = user.periods
            self.blocks = user.blocks
            self.events = user.events
            self.tasks = user.tasks
            self.sessions = user.sessions
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case new
        case email
        case imageUrl = "image_url"
        case apiToken = "api_token"
        case tasks
        case subjects
        case periods
        case sessions
        case events
        case blocks
    }
}




