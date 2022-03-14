//
//  AddPeriodController.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 6/2/22.
//
import UIKit
import SwiftUI
import SPIndicator

protocol UpdatePeriodList {
    func updateList()
}

class AddPeriodController: UIViewController {
    
    var period: PTPeriod?
    var subjects: [PTSubject]?
    var selectedSubjects: [PTSubject]?
    var userIsEditing: Bool?
    var delegate: UpdatePeriodList?
    var isNewPeriod: Bool?
    
    @IBOutlet weak var periodTableView: UITableView!
    @IBOutlet weak var editPeriod: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSubjects = period?.subjects
        subjects = PTUser.shared.subjects
        if let isNewPeriod = isNewPeriod, isNewPeriod {
            period = PTPeriod(id: nil, name: "Periodo nuevo", startDate: Date.now, endDate: Date.now, subjects: [], blocks: nil)
            selectedSubjects = []
            userIsEditing = true
            editPeriod.title = "Guardar"
        } else {
            userIsEditing = false
        }
        periodTableView.dataSource = self
        periodTableView.delegate = self
        periodTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let periodController = self.presentingViewController as? PeriodsController{
            periodController.updateList()
        }
    }
    
    
    @IBAction func editPeriod(_ sender: Any) {
        if let editing = userIsEditing {
            if editing {
                userIsEditing = false
                editPeriod.title = "Editar"
                periodTableView.reloadData()
                if let isNewPeriod = isNewPeriod, isNewPeriod{
                    NetworkingProvider.shared.createPeriod(period: period!) { periodId in
                        self.period!.id = periodId
                        PTUser.shared.periods?.append(self.period!)
                        let image = UIImage.init(systemName: "checkmark.circle")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysOriginal)
                        let indicatorView = SPIndicatorView(title: "Periodo añadido", preset: .custom(image))
                        indicatorView.present(duration: 3, haptic: .success, completion: nil)
                    } failure: { msg in
                        
                    }
                    self.isNewPeriod = false
                    delegate?.updateList()

                } else {
                    if let index = PTUser.shared.periods?.firstIndex(where: { userPeriod in
                        period!.id == userPeriod.id
                    }) {
                        PTUser.shared.periods?[index] = period!
                    }
                    PTUser.shared.savePTUser()
                    if let period = period {
                        NetworkingProvider.shared.editPeriod(period: period) { msg in
                            let image = UIImage.init(systemName: "checkmark.circle")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysOriginal)
                            let indicatorView = SPIndicatorView(title: "Periodo guardado", preset: .custom(image))
                            indicatorView.present(duration: 3, haptic: .success, completion: nil)
                        } failure: { msg in
                           
                        }
                        delegate?.updateList()
                    }
                }
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
            if let subject = subjects {
                return subject.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section){
        case 0:
            return "Detalles"
        case 1:
            return "Asignaturas"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
            
            if let subjectForCell = subjects?[indexPath.row] {
                cell.subjectName.text = subjectForCell.name
                cell.subjectColor.backgroundColor = UIColor(subjectForCell.color)
                if let bool = period?.subjects?.contains(where: { subject in
                    return subject.id == subjectForCell.id
                }), bool {
                    cell.checkSubject.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    cell.checkSubject.tintColor = UIColor(named: "AccentColor")
                    if userIsEditing! {
                        cell.subjectName.isEnabled = true
                        cell.subjectColor.isEnabled = true
                    } else {
                        cell.subjectName.isEnabled = false
                        cell.subjectColor.isEnabled = false
                    }
                } else {
                    cell.checkSubject.setImage(UIImage(systemName: "xmark"), for: .normal)
                    cell.checkSubject.tintColor = UIColor.red
                    cell.subjectName.isEnabled = false
                    cell.subjectName.alpha = 0.5
                    cell.subjectColor.isEnabled = false
                    cell.subjectColor.alpha = 0.5
                }
                
                cell.subjectColorDelegate = self
                cell.selectedSubjectDelegate = self
                cell.delegate = self
                if let editing = userIsEditing, editing == true {
                    cell.checkSubject.isEnabled = true
                } else {
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
            if let subjectIndex = periodTableView.indexPath(for: cell)?.row {
                if selected {
                    if let subject = subjects?[subjectIndex] {
                        selectedSubjects?.append(subject)
                    }
                } else {
                    if let subjectToRemove = subjects?[subjectIndex], let indexToRemove = selectedSubjects?.firstIndex(where: { subject in
                        subject.id == subjectToRemove.id
                    }) {
                        selectedSubjects?.remove(at: indexToRemove)
                    }
                }
                period!.subjects = selectedSubjects
        }
    }
    
    func colorPicked(_ cell: SubjectTableViewCell, color: String) {
        if let index = periodTableView.indexPath(for: cell)?.row {
            PTUser.shared.subjects?[index].color = color
            if let indexInSelectedSubjects = selectedSubjects?.firstIndex(where: { subject in
                subject.id == PTUser.shared.subjects?[index].id
            }) {
                selectedSubjects?[indexInSelectedSubjects].color = color
            }
            if let indexInPeriodSubject = period?.subjects?.firstIndex(where: { subject in
                subject.id == PTUser.shared.subjects?[index].id
            }) {
                period?.subjects?[indexInPeriodSubject].color = color
            }
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
        //        let indexPath = periodTableView.indexPath(for: cell)
        //        if let index = indexPath?.row, let text = editingText{
        //            period?.subjects?[index].name = text
        //        }
        if let index = periodTableView.indexPath(for: cell)?.row {
            PTUser.shared.subjects?[index].name = editingText!
            if let indexInSelectedSubjects = selectedSubjects?.firstIndex(where: { subject in
                subject.id == PTUser.shared.subjects?[index].id
            }) {
                selectedSubjects?[indexInSelectedSubjects].name = editingText!
            }
            if let indexInPeriodSubject = period?.subjects?.firstIndex(where: { subject in
                subject.id == PTUser.shared.subjects?[index].id
            }) {
                period?.subjects?[indexInPeriodSubject].name = editingText!
            }
        }
    }
    
    func didDateEndEditing(_ cell: DateTableViewCell, editingDate: Date?) {
        let indexPath = periodTableView.indexPath(for: cell)
        if let index = indexPath?.row, let date = editingDate {
            if index == 1{
                period?.startDate = date
            }
            if index == 2{
                period?.endDate = date
            }
        }
    }
    
    func didTextEndEditing(_ cell: NameTableViewCell, editingText: String?) {
        if let text = editingText {
            period?.name = text
            
        }
    }
}

