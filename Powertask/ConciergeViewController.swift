//
//  ConciergeViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 28/2/22.
//

import UIKit
import GoogleSignIn

class ConciergeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "toMain", sender: nil)
//        if LandscapeManager.shared.isFirstLaunch {
//            performSegue(withIdentifier: "toOnboarding", sender: nil)
//            LandscapeManager.shared.isFirstLaunch = true
//        } else {
//            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                if user == nil || error != nil {
//                    if LandscapeManager.shared.isThereUserData {
//                        self.performSegue(withIdentifier: "toMain", sender: nil)
//                    } else {
//                        self.performSegue(withIdentifier: "toMain", sender: nil)
//                    }
//                } else {
//                    self.performSegue(withIdentifier: "toMain", sender: nil)
//
//                }
//            }
//        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class LandscapeManager {
    static let shared = LandscapeManager()
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
//        var isLoggedOnGoogle: Bool {
//            get {
//                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                    if user == nil || error != nil {
//                        return true
//                    } else {
//                        return false
//                    }
//                }
//            }
//        }
//
    var isThereUserData: Bool {
        get {
            let decoder = JSONDecoder()
            if let data = try? UserDefaults.standard.object(forKey: "user") as? Data, let loggedUser = try? decoder.decode(PTUser.self, from: data), let api = loggedUser.apiToken {
                loadUser(userFromDefaults: loggedUser)
                return true
            } else {
                return false
            }
        }
    }
    
    func loadUser(userFromDefaults: PTUser) {
        PTUser.shared.id = userFromDefaults.id
        PTUser.shared.apiToken = userFromDefaults.apiToken
        PTUser.shared.name = userFromDefaults.name
        PTUser.shared.email = userFromDefaults.email
        PTUser.shared.imageUrl = userFromDefaults.imageUrl
        PTUser.shared.subjects = userFromDefaults.subjects
        PTUser.shared.periods = userFromDefaults.periods
        PTUser.shared.blocks = userFromDefaults.blocks
        PTUser.shared.events = userFromDefaults.events
        PTUser.shared.tasks = userFromDefaults.tasks
        PTUser.shared.sessions = userFromDefaults.sessions
        print(PTUser.self)
    }
}

extension UIStoryboard {
    static let onboarding = UIStoryboard(name: "OnBoarding", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
