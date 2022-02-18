//
//  MockRequestViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import UIKit
import GoogleSignIn

class MockRequestViewController: UIViewController {
    let signInConfig = GIDConfiguration.init(clientID: "399583491262-t0eqglos49o9iau47dker4v27bm2mt0j.apps.googleusercontent.com")
    var superUser: GIDGoogleUser? = GIDGoogleUser()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Supporting functions
    func signIn() {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            self.requestScopes()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }

    func requestScopes() {
        let additionalScopes = ["https://www.googleapis.com/auth/classroom.announcements.readonly",
                                "https://www.googleapis.com/auth/classroom.courses.readonly",
                                "https://www.googleapis.com/auth/classroom.coursework.me.readonly",
                                "https://www.googleapis.com/auth/classroom.courseworkmaterials.readonly"]
        GIDSignIn.sharedInstance.addScopes(additionalScopes, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            self.superUser = user
            let driveScope = "https://www.googleapis.com/auth/classroom.courses.readonly"
            let grantedScopes = user.grantedScopes
            if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
              print("request again")
            }
        }
        
    }
    
    func requestTest(user: GIDGoogleUser) {
        NetworkingProvider.shared.listTasks(success: { tasks in
            print(tasks)
        }, failure: { msg in
            print(msg)
        }, token: user.authentication.accessToken)
        
        user.authentication.do { authentication, error in
               guard error == nil else { return }
               guard let authentication = authentication else { return }

               let idToken = authentication.idToken
            NetworkingProvider.shared.listTasks(success: { tasks in
                print(tasks)
            }, failure: { msg in
                print(msg)
            }, token: user.authentication.accessToken)
           }
    }

    // MARK: - Navigation
    @IBAction func signIn(_ sender: Any) {
        signIn()
    }
    
    @IBAction func signOut(_ sender: Any) {
        signOut()
    }
    @IBAction func getTaskList(_ sender: Any) {
        if let user = superUser {
            requestTest(user: user)

        }
    }
    @IBAction func getSubjects(_ sender: Any) {
        NetworkingProvider.shared.createTask(success: { msg in
            print(msg)
        }, failure: { msg in
            print(msg)
        }, task: PTTask(id: 2, googleId: nil, name: "Prueba", startDate: Date(timeIntervalSince1970: 234234234), handoverDate: nil, mark: nil, description: "Prueba", completed: true, subject: MockUser.subjects[0], studentId: 2, subtasks: nil, serverHandoverDate: nil, serverStartDate: nil), token: "prueba")
    }
    
    
}
