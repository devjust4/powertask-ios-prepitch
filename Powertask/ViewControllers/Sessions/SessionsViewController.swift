//
//  SessionsViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 14/1/22.
//

import UIKit
import SwiftUI
class SessionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentSwiftUIView()
        // Do any additional setup after loading the view.
    }
    
    func presentSwiftUIView() {
        let contenView = ContentView()
        let hostingController = UIHostingController(rootView: contenView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            hostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            hostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
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
