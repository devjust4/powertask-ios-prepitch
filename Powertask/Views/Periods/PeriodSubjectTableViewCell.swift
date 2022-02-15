//
//  SubjectCell.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//

import UIKit
class SubjectTableViewCell: UITableViewCell {
    

    @IBOutlet weak var subjectName: UITextView!
    @IBOutlet weak var checkSubject: UIButton!
    @IBOutlet weak var subjectColor: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subjectColor.layer.cornerRadius = 8
        
    }
    @IBAction func checkSubject(_ sender: UIButton) {
        if checkSubject.imageView?.alpha == 1{
            checkSubject.imageView?.alpha = 0
            
        }else{
            checkSubject.imageView?.alpha = 1
        }
    }
    
    
}
