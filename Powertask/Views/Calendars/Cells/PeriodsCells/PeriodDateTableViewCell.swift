//
//  PeriodDateTableViewCell.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//

import UIKit

class DateTableViewCell: UITableViewCell{
    
    @IBOutlet weak var periodTime: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
