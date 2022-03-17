//
//  ConciergeViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 28/2/22.
//

import UIKit
import GoogleSignIn
import SPIndicator

class ConciergeViewController: UIViewController {
    let signInConfig = GIDConfiguration.init(clientID: "399583491262-t0eqglos49o9iau47dker4v27bm2mt0j.apps.googleusercontent.com")
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                    GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: self) { user, error in
                        let image = UIImage.init(systemName: "checkmark.circle")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysOriginal)
                        let indicatorView = SPIndicatorView(title: "Sesión iniciada correctamente", preset: .custom(image))
                        indicatorView.present(duration: 3, haptic: .success, completion: nil)
                    }
                }
            }
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
