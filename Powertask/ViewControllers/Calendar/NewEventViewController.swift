//
//  VacationViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 4/2/22.
//

import UIKit
import CoreData

protocol NewEventProtocol: AnyObject {
    func SaveNewEvent(eventTitle: String, startDate: Date?, endDate: Date?, subject: PTSubject?,  notes: String?)
}

class NewEventViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var eventDetailsTable: UITableView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var isNewEvent: Bool?
    var event: PTEvent?
    var delegate: NewEventProtocol?
    var eventName: String?
    var eventType: EventType?
    var eventStartDate: Date?
    var eventEndDate: Date?
    var eventSubject: PTSubject?
    var eventNotes: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventDetailsTable.delegate = self
        eventDetailsTable.dataSource = self
        background.layer.cornerRadius = 30
        
        // TODO: Controlar el ancho de las filas según el contenido para que el texto pueda fluir
        if let event = event {
            eventName = event.name
            eventType = event.type
            eventStartDate = event.startDate
            if let endDate = event.endDate {
                eventEndDate = endDate
            }
            if let subject = event.subject {
                eventSubject = subject
            }
            // TODO: NOTAS!!!
        }
        
        if let eventType = eventType {
            heightConstraint.constant = eventType == EventType.vacation ? 300 : 480
            if let isNewEvent = isNewEvent {
                let eventTitleTextIntro = isNewEvent ? "Nuevo " : "Editar "
                titleLabel.text = eventTitleTextIntro + eventType.rawValue
            }
        }
    }
    @IBAction func saveEvent(_ sender: Any) {
        
    }
    
    @objc func openSubjectSelectorVC(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "SubjectSelector") as? SubjectSelectorViewController {
            viewController.delegate = sender as? SubjectDelegate
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension NewEventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let type = eventType {
            switch type {
            case .vacation:
                return 1
            case .exam:
                return 3
            case .personal:
                return 2
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if eventType == EventType.exam {
                return 2
            } else {
                return 3
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell {
                    if let name = eventName {
                        cell.textField.text = name
                    }
                    cell.delegate = self
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as? DatePickerTableViewCell {
                    cell.datePicker.minimumDate = Date.now
                    if let startDate = eventStartDate {
                        cell.datePicker.date = startDate
                    }
                    cell.datePicker.datePickerMode = eventType == EventType.vacation ? .date : .dateAndTime
                    cell.label.text = eventType == EventType.exam ? "Fecha" : "Empieza"
                    cell.delegate = self
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as? DatePickerTableViewCell {
                    cell.datePicker.minimumDate = Date.now
                    if let endDate = eventEndDate {
                        cell.datePicker.date = endDate
                    }
                    cell.datePicker.datePickerMode = eventType == EventType.vacation ? .date : .dateAndTime
                    cell.label.text = "Termina"
                    cell.delegate = self
                    return cell
                }
            default:
                return UITableViewCell()
            }
        case 1:
            if eventType == EventType.personal {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "textViewTableViewCell", for: indexPath) as? TextViewTableViewCell {
                    cell.delegate = self
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as? ButtonTableViewCell {
                    cell.label.text = eventType == EventType.exam ? "Asignatura" : "Calendario"
                    if let subject = eventSubject {
                        cell.button.setTitle(subject.name, for: .normal)
                        cell.button.tintColor = subject.color
                    }
                    cell.buttonDelegate = self
                    return cell
                }
            }
            
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "textViewTableViewCell", for: indexPath) as? TextViewTableViewCell{
                cell.delegate = self
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension NewEventViewController: CellTextFieldProtocol, CellButtonPushedDelegate, CellDatePickerProtocol, CellTextViewProtocol, CellButtonSubjectDelegate {
    func subjectSelected(_ subject: PTSubject) {
        eventSubject = subject
    }
    
    func didTextEndEditing(_ cell: TextFieldTableViewCell, editingText: String?) {
        eventName = editingText
    }
    
    func cellButtonPushed(_ cell: ButtonTableViewCell) {
        cell.subjectDelegate = self
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "SubjectSelector") as? SubjectSelectorViewController {
            viewController.delegate = cell
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func didSelectDate(_ cell: DatePickerTableViewCell, dateSelected: Date) {
        // TODO: Evitar este truco con las fechas y mostrar en rojo cuando se seleccione erroneamente
        if eventStartDate == nil {
            eventStartDate = dateSelected
        } else {
            if eventStartDate! > dateSelected {
                eventEndDate = eventStartDate
                eventStartDate = dateSelected
            } else {
                eventEndDate = dateSelected
            }
        }
        print("inicio: \(eventStartDate) fin: \(eventEndDate)")
    }
    
    func textviewCellEndEditing(_ cell: TextViewTableViewCell, editChangedWithText: String) {
        eventDetailsTable.beginUpdates()
        eventDetailsTable.endUpdates()
        eventNotes = editChangedWithText
        print(editChangedWithText)
    }
}


