//
//  AddPeriodController.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//  Eddited by Daniel Torres on 15/2/22.
//

import UIKit
class AddPeriodController: UIViewController {
    
    var period: Period?
    var subject: [Subject]?
    var userIsEditing: Bool?
    var periodName: String?
    var endDate: Date?
    var startDate: Date?
    var subjectName: String?
    
    @IBOutlet weak var periodTableView: UITableView!
    @IBOutlet weak var editPeriod: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject = MockUser.user.subjects
        
        userIsEditing = false
        periodTableView.dataSource = self
        periodTableView.delegate = self
        periodTableView.reloadData()
    }

   
    
    @IBAction func editPeriod(_ sender: Any) {
        if let editing = userIsEditing {
            if editing {
                userIsEditing = false
                saveData()
                editPeriod.title = "Editar"
                periodTableView.reloadData()
            } else {
                userIsEditing =  true
                editPeriod.title = "Guardar"
                periodTableView.reloadData()
            }
        }
    }
}

extension AddPeriodController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
   }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }else if section == 1{
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
            case 1:
                name = "Subjects"
                break
            default:
                name = ""
                break
        }
        return name
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
//        indexDate = indexPath
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
                
                cell.setPeriodName.isEnabled = userIsEditing! ? true : false
                cell.setPeriodName.text = period?.name
                cell.delegate = self
                return cell
            }else if indexPath.row == 1{
                print(indexPath.row)
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
                cell.periodTime.text =  "Inicio"
                cell.datePicker.isEnabled = userIsEditing! ? true : false
                cell.delegate = self
                if period?.startDate == nil{
                    cell.datePicker.setDate(Date.now, animated: false)
                }else{
                    cell.datePicker.setDate((period?.startDate)!, animated: false)
                }
                return cell
            }else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
                cell.periodTime.text = "Fin"
                cell.datePicker.isEnabled = userIsEditing! ? true : false
                cell.delegate = self
                if period?.endDate == nil{
                    cell.datePicker.setDate(Date.now, animated: false)
                }else{
                    cell.datePicker.setDate((period?.endDate)!, animated: false)
                }
                return cell
            }
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectTableViewCell
            
            if let subject = subject?[indexPath.row] {
                cell.subjectName.text = subject.name
                cell.subjectColor.backgroundColor = subject.color
                cell.checkSubject.isHidden = false
                cell.subjectName.isEditable = userIsEditing! ? true : false
                cell.subjectColorDelegate = self
                cell.delegate = self
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
    
    func saveData(){
        if let periodName = periodName{
            period?.name = periodName
        }
        if startDate != nil{
            period?.startDate = startDate
        }
        if endDate != nil{
            period?.endDate = endDate
        }
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
            subject?[index].color = color
        }
    }
    
    func instanceColorPicker(_ cell: SubjectTableViewCell) {
        let colorViewController = UIColorPickerViewController()
        colorViewController.delegate = cell
        self.present(colorViewController, animated: true, completion: nil)
    }
}

extension AddPeriodController: PeriodNameTextFieldProtocol, PeriodDatePickerProtocol, PeriodSubjectTextViewProtocol{
    
    func didTextEndEditing(_ cell: SubjectTableViewCell, editingText: String?) {
        let indexPath = periodTableView.indexPath(for: cell)
        if let index = indexPath?.row, let text = editingText{
            subject?[index].name = text
        }
    }
    
    func didDateEndEditing(_ cell: DateTableViewCell, editingDate: Date?) {
        let indexPath = periodTableView.indexPath(for: cell)
        if let index = indexPath?.row {
            if index == 1{
                startDate = editingDate
            }
            if index == 2{
                endDate = editingDate
            }
        }
    }
    
    func didTextEndEditing(_ cell: NameTableViewCell, editingText: String?) {
        periodName = editingText
    }
}
    


