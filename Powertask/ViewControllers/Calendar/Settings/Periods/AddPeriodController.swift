//
//  AddPeriodController.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//

import UIKit
class AddPeriodController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var period: Periods?
    var subject: [Subject]?
    var UserIsEditing: Bool?
    var indexSubject: Int?
    
    @IBOutlet weak var PeriodTableView: UITableView!
    
    @IBOutlet weak var editPeriod: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject = [Subject(name: "iOS", color: .red), Subject(name: "Acceso a datos", color: .blue), Subject(name: "ingles", color: .green)]
        
        PeriodTableView.dataSource = self
        PeriodTableView.delegate = self
        PeriodTableView.reloadData()
        UserIsEditing = false
    
    }

    func numberOfSections(in tableView: UITableView) -> Int {
       return 3
   }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 2
        }else if section == 2{
            if let subject = subject {
                return subject.count
            }
        }
        
       return 0
   }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var name = ""
        switch (section){
            case 0:
                name = "Details"
                break
            case 2:
                name = "Subjects"
                break
            default:
                name = ""
                break
        }
        return name
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexSubject = indexPath.row
       
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
            
            cell.setPeriodName.isEnabled = UserIsEditing! ? true : false
            cell.setPeriodName.text = period?.name
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
            cell.datePicker.isEnabled = UserIsEditing! ? true : false
            if indexPath.row == 0{
                cell.periodTime.text =  "Inicio"
                cell.datePicker.setDate((period?.startDate)!, animated: false)
            }else if indexPath.row == 1{
                cell.periodTime.text = "Fin"
                cell.datePicker.setDate((period?.endDate)!, animated: false)
            }
            
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectTableViewCell
            
            if let subject = subject?[indexPath.row] {
                cell.subjectName.text = subject.name
                cell.subjectColor.backgroundColor = subject.color
                cell.checkSubject.isHidden = false
                cell.subjectName.isEditable = UserIsEditing! ? true : false
                cell.delegate = self
            }
            return cell
        }
        return cell
   }
    
    @IBAction func editPeriod(_ sender: Any) {
        if editPeriod.title == "Edit"{
            UserIsEditing =  true
            PeriodTableView.reloadData()
            editPeriod.title = "Save"
        }else if editPeriod.title == "Save"{
            UserIsEditing = false
            PeriodTableView.reloadData()
            editPeriod.title = "Edit"
        }
        
    }
    
    @IBAction func subjectColor(_ sender: Any) {
//            if let viewController = storyboard?.instantiateViewController(withIdentifier: "selectColorSubject") as? SubjectSelectorViewController {
//                viewController.subject = subject?[indexSubject!]
//                self.present(viewController, animated: true, completion: nil)
//        }
    }
    
}

extension AddPeriodController: ColorButtonPushedProtocol, UIColorPickerViewControllerDelegate {
    func instanceColorPicker(_ cell: SubjectTableViewCell) {
        let colorViewController = UIColorPickerViewController()
        //colorViewController.delegate = cell
        self.present(colorViewController, animated: true, completion: nil)
    }
}
    


