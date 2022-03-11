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
        PTUser.shared.apiToken = "$2y$10$4a3ak8C77Imto7zr900mUOXHnoJVRV2Xv2t1joyE7zeAopNLMjNAW"
        let myblocks = [PTBlock(timeStart: Date.now, timeEnd: Date.now, day: 1, subject: PTUser.shared.subjects![0])]
        var myPeriod = PTUser.shared.periods![0]
        myPeriod.subjects = PTUser.shared.subjects
        myPeriod.blocks = myblocks
        
        print(myPeriod.subjects)
        print(myPeriod.blocks)
        
        NetworkingProvider.shared.listSubjects { subjects in
            print("dale")
        } failure: { error in
            print("no dale")
        }

        
        
        NetworkingProvider.shared.createPeriod(period: myPeriod) { periodId in
            print("creado")
        } failure: { msg in
            print("no creado")
        }

        
        
        NetworkingProvider.shared.editPeriod(period: myPeriod) { msg in
            print("prueba superada")
        } failure: { msg in
            print("prueba fallida")
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
