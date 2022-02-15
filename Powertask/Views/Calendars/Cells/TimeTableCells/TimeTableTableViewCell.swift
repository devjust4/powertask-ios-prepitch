//
//  TImeTableTableViewCell.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import UIKit

class TimeTableTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectDropZone: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let dropInteraction = UIDropInteraction(delegate: self)
        subjectDropZone.addInteraction(dropInteraction)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TimeTableTableViewCell: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        print("enter")
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIColor.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIColor.self) { colorObject in
            let color = colorObject as! [UIColor]
            self.subjectDropZone.backgroundColor = color.first
        }
    }
}
