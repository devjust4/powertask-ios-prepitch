//
//  AddPeriodController.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//  Eddited by Daniel Torres on 15/2/22.
//

import UIKit
class AddPeriodController: UIViewController {
    var period: PTPeriod?
    var subject: [PTSubject]?
    var userIsEditing: Bool?
    var indexSubject: Int?
    
    @IBOutlet weak var periodTableView: UITableView!
    @IBOutlet weak var editPeriod: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject = MockUser.user.subjects
        
        periodTableView.dataSource = self
        periodTableView.delegate = self
        periodTableView.reloadData()
        userIsEditing = false
    }

   
    
    @IBAction func editPeriod(_ sender: Any) {
        if let editing = userIsEditing {
            if editing {
                userIsEditing = false
                periodTableView.reloadData()
                editPeriod.title = "Editar"
                periodTableView.reloadData()
            } else {
                userIsEditing =  true
                periodTableView.reloadData()
                editPeriod.title = "Guardar"
                periodTableView.reloadData()
            }
        }
    }
}

extension AddPeriodController: UITableViewDataSource, UITableViewDelegate{
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
        switch (section){
            case 0:
                return "Detalles"
            case 2:
                return "Asignaturas"
            default:
                return ""
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSubject = indexPath.row
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
            
            cell.setPeriodName.isEnabled = userIsEditing! ? true : false
            cell.setPeriodName.text = period?.name
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
            cell.datePicker.isEnabled = userIsEditing! ? true : false
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
                cell.subjectName.isEditable = userIsEditing! ? true : false
                cell.subjectColorDelegate = self
                if let editing = userIsEditing, editing == true {
                    cell.subjectName.isEditable = true
                    cell.subjectColor.isEnabled = true
                    cell.checkSubject.isEnabled = true
                } else {
                    cell.subjectName.isEditable = false
                    cell.subjectColor.isEnabled = false
                    cell.checkSubject.isEnabled = false
                }
            }
            return cell
        }
        return cell
   }
}

extension AddPeriodController: ColorButtonPushedProtocol, UIColorPickerViewControllerDelegate, SubjectSelectedDelegate {
    func markSubjectSelected(_ cell: SubjectTableViewCell, selected: Bool) {
        if let index = periodTableView.indexPath(for: cell)?.row {
            // marcar asignatura como perteneciente al periodo en el que se está
        }
    }
    
    func colorPicked(_ cell: SubjectTableViewCell, color: UIColor) {
        if let index = periodTableView.indexPath(for: cell)?.row {
            MockUser.subjects[index].color = color
        }
    }
    
    func instanceColorPicker(_ cell: SubjectTableViewCell) {
        let colorViewController = UIColorPickerViewController()
        colorViewController.delegate = cell
        self.present(colorViewController, animated: true, completion: nil)
    }
}
    


