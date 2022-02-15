//
//  SubjectCell.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//

protocol ColorButtonPushedProtocol {
    func instanceColorPicker(_ cell: SubjectTableViewCell)
    func colorPicked(_ cell: SubjectTableViewCell, color: UIColor)
}

import UIKit
class SubjectTableViewCell: UITableViewCell {
    

    @IBOutlet weak var subjectName: UITextView!
    @IBOutlet weak var checkSubject: UIButton!
    @IBOutlet weak var subjectColor: UIButton!
    var delegate: ColorButtonPushedProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subjectColor.layer.cornerRadius = 8
        
    }
    @IBAction func selectColor(_ sender: Any) {
        delegate?.instanceColorPicker(self)
    }
    @IBAction func checkSubject(_ sender: UIButton) {
        if checkSubject.imageView?.alpha == 1{
            checkSubject.imageView?.alpha = 0
            
        }else{
            checkSubject.imageView?.alpha = 1
        }
    }
}

extension SubjectTableViewCell: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        subjectColor.backgroundColor = color
        delegate?.colorPicked(self, color: color)
    }
}
