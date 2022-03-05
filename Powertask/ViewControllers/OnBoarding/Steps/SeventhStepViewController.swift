//
//  SeventhStepViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 5/3/22.
//

import UIKit

class SeventhStepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func beginTheApp(_ sender: Any) {
        if let new = PTUser.shared.new, new {
            if let pageController = self.parent as? OnBoardingViewController {
                pageController.goNext()
            }
        } else {
            performSegue(withIdentifier: "GoToMain", sender: nil)
        }
    }
    

}
