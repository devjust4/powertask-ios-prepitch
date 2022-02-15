//
//  SubjectCell.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//  Eddited by Daniel Torres on 15/2/22.
//

protocol ColorButtonPushedProtocol {
    func instanceColorPicker(_ cell: SubjectTableViewCell)
    func colorPicked(_ cell: SubjectTableViewCell, color: UIColor)
}

protocol SubjectSelectedDelegate {
    func markSubjectSelected(_ cell: SubjectTableViewCell, selected: Bool)
}

import UIKit
class SubjectTableViewCell: UITableViewCell {
    @IBOutlet weak var subjectName: UITextView!
    @IBOutlet weak var checkSubject: UIButton!
    @IBOutlet weak var subjectColor: UIButton!
    var subjectColorDelegate: ColorButtonPushedProtocol?
    var selectedSubjectDelegate: SubjectSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subjectColor.layer.cornerRadius = 8
    }
    
    @IBAction func selectColor(_ sender: Any) {
        subjectColorDelegate?.instanceColorPicker(self)
    }
    
    @IBAction func checkSubject(_ sender: UIButton) {
        if checkSubject.imageView?.alpha == 1{
            checkSubject.imageView?.alpha = 0
            selectedSubjectDelegate?.markSubjectSelected(self, selected: false)
        }else {
            checkSubject.imageView?.alpha = 1
            selectedSubjectDelegate?.markSubjectSelected(self, selected: true)
        }
    }
}

extension SubjectTableViewCell: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        subjectColor.backgroundColor = color
        subjectColorDelegate?.colorPicked(self, color: color)
    }
}
