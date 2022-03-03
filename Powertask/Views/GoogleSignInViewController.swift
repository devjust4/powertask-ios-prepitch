//
//  GoogleSignInViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 28/2/22.
//

import UIKit
import GoogleSignIn

class GoogleSignInViewController: UIViewController {
    let signInConfig = GIDConfiguration.init(clientID: "399583491262-t0eqglos49o9iau47dker4v27bm2mt0j.apps.googleusercontent.com")
    var superUser: GIDGoogleUser? = GIDGoogleUser()
    
    @IBOutlet weak var signInWithGoogleButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInWithGoogleButton.colorScheme = .light
        signInWithGoogleButton.style = .wide
    }
    
    
    
    
    // MARK: - Navigation
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            self.performSegue(withIdentifier: "toMain", sender: self)
          }
    }
    
}
