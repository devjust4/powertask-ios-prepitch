//
//  SubjectDropZone.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import UIKit

class SubjectDropZone: UIView, UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIColor.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIColor.self) { colorObject in
            let color = colorObject as! [UIColor]
            self.backgroundColor = color.first
        }
    }
}
