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

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
