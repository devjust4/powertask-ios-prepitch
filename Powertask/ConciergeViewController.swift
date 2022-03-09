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
//        let blocks = [0: [PTSendableBlock(timeStart: Date.now.timeIntervalSince1970, timeEnd: Date.now.timeIntervalSince1970, subjectID: 3)]]
//        //let enconder = try? JSONEncoder().encode(blocks)
//        if let data = try? JSONEncoder().encode(blocks) {
//            print(data)
//        print(String(data: data, encoding: String.Encoding.utf8)!)
//        }
        PTUser.shared.apiToken = "$2y$10$Jk9Wxx8SWxoFyuK2W/TZwuxbevCj3olp76EQWsW2AXVYB0ejFKmZa"
        var sendableBlocks = [0 : [PTSendableBlock(timeStart: 123123, timeEnd: 123124, subjectID: 1)], 1 : [], 2 : [], 3 : [], 4 : [PTSendableBlock(timeStart: 123123, timeEnd: 123124, subjectID: 1)], 5 : [], 6 : []]
        NetworkingProvider.shared.createBlock(blocks: sendableBlocks, periodID: 1) { blockId in
            print("hecho")
        } failure: { msg in
            print("error")
        }

        if LandscapeManager.shared.isFirstLaunch {
            performSegue(withIdentifier: "toOnboarding", sender: nil)
        } else {
            if LandscapeManager.shared.isThereUserData {
                self.performSegue(withIdentifier: "toMain", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toOnboarding", sender: nil)
            }
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if user == nil || error != nil {
                    
                }
            }
            
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
        }
    }
    

    
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
            if let _ = UserDefaults.standard.codableObject(dataType: PTUser.self, key: "user") {
                PTUser.shared.loadPTUser()
                return true
            } else {
                return false
            }
        }
    }
}

extension UIStoryboard {
    static let onboarding = UIStoryboard(name: "OnBoarding", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
