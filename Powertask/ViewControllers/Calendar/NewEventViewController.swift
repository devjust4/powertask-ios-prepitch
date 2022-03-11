//
//  VacationViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 4/2/22.
//

import UIKit
import CoreData
import SPIndicator

protocol NewEventProtocol: AnyObject {
    func SaveNewEvent(event: PTEvent, isNewEvent: Bool)
}

class NewEventViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var eventDetailsTable: UITableView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var isNewEvent: Bool?
    var selectedDate: Date?
    var event: PTEvent?
    var delegate: NewEventProtocol?
    var eventId: Int?
    var eventName: String?
    var eventType: EventType?
    var eventStartDate: Date?
    var eventEndDate: Date?
    var eventSubject: PTSubject?
    var eventNotes: String?
    var allDay: Bool?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventDetailsTable.delegate = self
        eventDetailsTable.dataSource = self
        background.layer.cornerRadius = 30
        
        // TODO: Controlar el ancho de las filas según el contenido para que el texto pueda fluir
        if let event = event {
            eventId = event.id
            eventName = event.name
            eventType = event.type
            eventStartDate = event.startDate
            eventEndDate = event.endDate
            if let subject = event.subject {
                eventSubject = subject
            }
            if let notes = event.notes {
                eventNotes = notes
            }
            allDay = Bool(truncating: event.allDay as NSNumber)
        }
        
        if let eventType = eventType {
            heightConstraint.constant = eventType == EventType.vacation ? 300 : 480
            if let isNewEvent = isNewEvent {
                let eventTitleTextIntro = isNewEvent ? "Nuevo " : "Editar "
                switch eventType {
                case EventType.exam:
                    titleLabel.text = "\(eventTitleTextIntro)examen"
                case EventType.vacation:
                    titleLabel.text = "\(eventTitleTextIntro)festivo"
                case EventType.personal:
                    titleLabel.text = "\(eventTitleTextIntro)evento"
                }
            }
        }
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        if let eventType = eventType, let eventName = eventName, let startDate = eventStartDate, let endDate = eventEndDate {
            if eventType != EventType.exam && eventSubject != nil {
                delegate?.SaveNewEvent(event: PTEvent(id: eventId, name: eventName, type: eventType, allDay: allDay ?? false ? 1 : 0, notes: eventNotes, startDate: startDate, endDate: endDate, subject: eventSubject), isNewEvent: isNewEvent!)
                self.dismiss(animated: true)
            }
        } else {
            let image = UIImage.init(systemName: "textformat.abc.dottedunderline")!.withTintColor(UIColor(.red), renderingMode: .alwaysOriginal)
            let indicatorView = SPIndicatorView(title: "Rellena todos los datos", preset: .custom(image))
            indicatorView.present(duration: 3, haptic: .success, completion: nil)
        }
        
        if let eventName = eventName, let eventType = eventType, let startDate = eventStartDate, let endDate = eventEndDate {
            delegate?.SaveNewEvent(event: PTEvent(id: eventId, name: eventName, type: eventType, allDay: allDay ?? false ? 1 : 0, notes: eventNotes, startDate: startDate, endDate: endDate, subject: eventSubject), isNewEvent: isNewEvent!)
            self.dismiss(animated: true)
        }
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
            if let eventType = eventType, eventType == EventType.personal {
                return 4
            } else {
                return 3
            }
            return 0
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
                if eventType! == EventType.personal {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "allDaySwitch", for: indexPath) as? AllDaySwitchTableViewCell {
                        cell.delegate = self
                        cell.allDaySwitch.setOn(allDay ?? false, animated: true)
                        return cell
                    }
                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as? DatePickerTableViewCell {
                        cell.datePicker.datePickerMode = eventType == EventType.vacation ? .date : .dateAndTime
                        if let allDay = allDay, allDay {
                            cell.datePicker.datePickerMode = .date
                        }
                        cell.datePicker.minimumDate = Date.now
                        if let startDate = eventStartDate {
                            cell.datePicker.date = startDate
                        }
                        cell.label.text = "Empieza"
                        cell.delegate = self
                        return cell
                    }
                }
            case 2:
                if eventType! == EventType.personal {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as? DatePickerTableViewCell {
                        cell.datePicker.datePickerMode = eventType == EventType.vacation ? .date : .dateAndTime
                        if let allDay = allDay, allDay {
                            cell.datePicker.datePickerMode = .date
                        }
                        cell.datePicker.minimumDate = Date.now
                        if let startDate = eventStartDate {
                            cell.datePicker.date = startDate
                        } else if let selectedDate = selectedDate {
                            cell.datePicker.date = selectedDate
                        }
                        cell.label.text = "Empieza"
                        cell.delegate = self
                        return cell
                    }
                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as? DatePickerTableViewCell {
                        cell.datePicker.datePickerMode = eventType == EventType.vacation ? .date : .dateAndTime
                        if let allDay = allDay, allDay {
                            cell.datePicker.datePickerMode = .date
                        }
                        cell.datePicker.minimumDate = Date.now
                        if let endDate = eventEndDate {
                            cell.datePicker.date = endDate
                        } else if let selectedDate = selectedDate {
                            cell.datePicker.date = selectedDate
                        }
                        cell.label.text = "Termina"
                        cell.delegate = self
                        return cell
                    }
                }
            case 3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as? DatePickerTableViewCell {
                    cell.datePicker.datePickerMode = eventType == EventType.vacation ? .date : .dateAndTime
                    if let allDay = allDay, allDay {
                        cell.datePicker.datePickerMode = .date
                    }
                    cell.datePicker.minimumDate = Date.now
                    if let endDate = eventEndDate {
                        cell.datePicker.date = endDate
                    } else if let selectedDate = selectedDate {
                        cell.datePicker.date = selectedDate
                    }
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
                    cell.textField.text = eventNotes
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as? ButtonTableViewCell {
                    cell.label.text = eventType == EventType.exam ? "Asignatura" : "Calendario"
                    if let subject = eventSubject {
                        cell.button.setTitle(subject.name, for: .normal)
                        cell.button.tintColor = UIColor(subject.color)
                    }
                    cell.buttonDelegate = self
                    return cell
                }
            }
            
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "textViewTableViewCell", for: indexPath) as? TextViewTableViewCell{
                cell.delegate = self
                cell.textField.text = eventNotes
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
    }
    
    func textviewCellEndEditing(_ cell: TextViewTableViewCell, editChangedWithText: String) {
        eventDetailsTable.beginUpdates()
        eventDetailsTable.endUpdates()
        eventNotes = editChangedWithText
        print(editChangedWithText)
    }
}

extension NewEventViewController: AllDaySwitchChanged {
    func allDaySwitchHasChanged(newAllDayValue: Bool) {
        allDay = newAllDayValue
        eventDetailsTable.reloadRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 3, section: 0)], with: .automatic)
    }
    
    
}


