//
//  OnBoardingViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 28/2/22.
//

import UIKit

class OnBoardingViewController: UIPageViewController {
    
    private var viewControllerList: [UIViewController] = {
        let storyboard = UIStoryboard.onboarding
        let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstStep")
        let secondVC = storyboard.instantiateViewController(withIdentifier: "TwoStep")
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdStep")
        let fourthVC = storyboard.instantiateViewController(withIdentifier: "FourthStep")
        let googleSignInVC = storyboard.instantiateViewController(withIdentifier: "GoogeSignIn")
        return [firstVC, secondVC, thirdVC, fourthVC, googleSignInVC]
    }()
    
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)
    }
    
    
    func goNext() {
        if currentIndex + 1 < viewControllerList.count {
            self.setViewControllers([self.viewControllerList[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
            currentIndex += 1
        }
    }
    
    func goBack() {
        if currentIndex - 1 > 0 {
            self.setViewControllers([self.viewControllerList[self.currentIndex - 1]], direction: .reverse, animated: true)
            currentIndex -= 1
        }
    }
}
