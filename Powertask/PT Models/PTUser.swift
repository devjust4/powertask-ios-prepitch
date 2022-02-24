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
    var apiToken: String?
    var name: String?
    var email: String?
    var imageUrl: String?
    var course: PTCourse?
    var subjects: [PTSubject]?
    var periods: [PTPeriod]?
    var blocks: [PTBlock]?
    var events: [[String : PTDay]]?
    var tasks: [PTTask]?
    var sessions: [PTSession]?
    
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
            self.course = user.course
            self.subjects = user.subjects
            self.periods = user.periods
            self.blocks = user.blocks
            self.events = user.events
            self.tasks = user.tasks
            self.sessions = user.sessions
        }
    }
}
