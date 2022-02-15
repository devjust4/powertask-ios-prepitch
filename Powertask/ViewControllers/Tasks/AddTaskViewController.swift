//
//  AddTaskViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 18/1/22.
//

import UIKit

// TODO: Validar campos de texto y poner limite de caracteres a la descripcion

protocol SaveNewTaskProtocol: AnyObject {
    func appendNewTask(newTask: UserTask)
}

class AddTaskViewController: UIViewController {
    var userIsEdditing = false
    var userTask: UserTask?
    var subject: Subject?
    var subtasks: [UserSubtask]?
    var delegate: SaveNewTaskProtocol?
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectButton: UIButton!
    
    @IBOutlet weak var handoverDatePicker: UIDatePicker!
    @IBOutlet weak var handoverDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var markTextField: UITextField!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var subtaskLabel: UILabel!
    @IBOutlet weak var subtaskTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var handoverDateLabelToSubjectLabel: NSLayoutConstraint!
    @IBOutlet weak var handoverDatePickerToSubjectButton: NSLayoutConstraint!
    
    @IBOutlet weak var startdatePickerToSubjectButton: NSLayoutConstraint!
    @IBOutlet weak var startdateLabelToSubjectLabel: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLabelToNote: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelToStartdateLabel: NSLayoutConstraint!
    @IBOutlet weak var markTextfieldToStartDatePicker: NSLayoutConstraint!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Interface config
        taskNameTextField.borderStyle = .none
        markTextField.borderStyle = .none
        handoverDatePicker.minimumDate = Date()
        startDatePicker.minimumDate = Date()
        subtaskTable.delegate = self
        subtaskTable.dataSource = self
        
       
        // MARK: - Data injection
        if let task = userTask {
            
            if task.classroomId == nil {
                handoverDatePicker.isHidden = true
                handoverDateLabel.isHidden = true
                handoverDateLabelToSubjectLabel.isActive = false
                handoverDatePickerToSubjectButton.isActive = false
                startdateLabelToSubjectLabel.isActive = true
                startdatePickerToSubjectButton.isActive = true
                markLabel.isHidden = true
                markTextField.isHidden = true
                descriptionLabelToNote.isActive = false
                descriptionLabelToStartdateLabel.isActive = true
                markTextfieldToStartDatePicker.isActive = false
            }
            
            taskNameTextField.text = task.name
            if let description = task.description{
                descriptionTextView.text = description
            }
            if let mark = task.mark {
                markTextField.text = String(format: "%.0f", mark)
            }
            
            if let subject = task.subject {
                subjectButton.setTitle(subject.name, for: .normal)
                subjectButton.tintColor = subject.color
            }
            if let dueDate = task.startDate {
                startDatePicker.setDate(dueDate, animated: false)
            }
            if let handoverDate = task.handoverDate {
                handoverDatePicker.setDate(handoverDate, animated: false)
            }
            if task.completed{
                doneButton.setImage(Constants.taskDoneImage, for: .normal)
                doneButton.tintColor = Constants.appColor
            } else {
                doneButton.setImage(Constants.taskUndoneImage, for: .normal)
                doneButton.tintColor = .black
            }
        } else {
            userIsEdditing = true
            handoverDatePicker.isHidden = true
            handoverDateLabel.isHidden = true
            handoverDateLabelToSubjectLabel.isActive = false
            handoverDatePickerToSubjectButton.isActive = false
            startdateLabelToSubjectLabel.isActive = true
            startdatePickerToSubjectButton.isActive = true
            markLabel.isHidden = true
            markTextField.isHidden = true
            descriptionLabelToNote.isActive = false
            descriptionLabelToStartdateLabel.isActive = true
            markTextfieldToStartDatePicker.isActive = false
        }
        
        if userIsEdditing {
            configInterfaceWhileEdditiing(isEdditing: true)
        }
    }
    
    // MARK: - Navigation
    @IBAction func setTaskDone(_ sender: Any) {
        if let task = userTask {
            if task.completed {
                doneButton.setImage(Constants.taskUndoneImage, for: .normal)
                doneButton.tintColor = .black
                task.completed = false
            } else {
                doneButton.setImage(Constants.taskDoneImage, for: .normal)
                doneButton.tintColor = Constants.appColor
                task.completed = true
            }
        }
    }
    
    @IBAction func editTask(_ sender: Any) {
        if userIsEdditing {
            saveData()
            configInterfaceWhileEdditiing(isEdditing: false)
            userIsEdditing = false
        } else {
            configInterfaceWhileEdditiing(isEdditing: true)
            userIsEdditing = true
        }
    }
    
    @IBAction func addSubtask(_ sender: Any) {
        if let subtasks = userTask?.subtasks{
            userTask?.subtasks?.append(UserSubtask(name: nil, done: false))
            subtaskTable.beginUpdates()
            subtaskTable.insertRows(at: [IndexPath(row: subtasks.count, section: 0)], with: .automatic)
            subtaskTable.endUpdates()
        } else {
            if let _ = subtasks {
                subtasks?.append(UserSubtask(name: nil, done: false))
            } else {
                subtasks = [UserSubtask(name: nil, done: false)]
            }
            subtaskTable.reloadData()
        }
    }
    
    // MARK: - Supporting Functions
    func configInterfaceWhileEdditiing(isEdditing: Bool){
        startDatePicker.isEnabled = isEdditing
        descriptionTextView.isEditable = isEdditing
        descriptionTextView.isSelectable = isEdditing
        addButton.isHidden = !isEdditing
        taskNameTextField.isEnabled = isEdditing
        markTextField.isEnabled = isEdditing
        if isEdditing {
            editButton.title = "Guardar"
        } else {
            editButton.title = "Editar"
        }
    }
    
    func setSubject(subject: Subject){
        if let _ = userTask {
            userTask!.subject = subject
            subjectButton.setTitle(subject.name, for: .normal)
            subjectButton.tintColor = subject.color
        }
    }
    
    func saveData(){
        if let userTask = userTask {
            userTask.name = taskNameTextField.text ?? "Tarea sin nombre"
            userTask.description = descriptionTextView.text
            // TODO: Controlar nota FLOAT?
            userTask.mark = Float(markTextField.text ?? "00")
            userTask.handoverDate = handoverDatePicker.date
            
            if !startDatePicker.isHidden {
                userTask.startDate = startDatePicker.date
            }
            // TODO: falta perform date
        } else {

            userTask = UserTask(completed: false, name: taskNameTextField.text ?? "Tarea sin nombre", subject: subject ?? Subject(name: "Sin Asignatura", color: .gray), description: descriptionTextView.text! , mark: 00, startDate: Date.now, subtasks: subtasks ?? [])
            delegate?.appendNewTask(newTask: userTask!)
        }
    }
    
    @IBAction func selectSubject(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "SubjectSelector") as? SubjectSelectorViewController {
            viewController.delegate = self
            viewController.subject = userTask?.subject
            self.present(viewController, animated: true, completion: nil)
    }
    
}
}

extension AddTaskViewController: SubjectDelegate, SubtaskCellTextDelegate, SubtaskCellDoneDelegate {
    func subtaskDonePushed(_ subtaskCell: UserSubtaskTableViewCell, subtaskDone: Bool?) {
        let indexPath = subtaskTable.indexPath(for: subtaskCell)
        if let row = indexPath?.row, let _ = userTask, let done = subtaskDone {
            userTask!.subtasks![row].done = done
        }
    }
    
    func subtaskCellEndEditing(_ subtaskCell: UserSubtaskTableViewCell, didEndEditingWithText: String?) {
        let indexPath = subtaskTable.indexPath(for: subtaskCell)
        if let row = indexPath?.row, let subtaskName = didEndEditingWithText {
            if let _ = userTask {
                userTask?.subtasks?[row].name = subtaskName
            } else if let _ = subtasks {
                subtasks?[row].name = subtaskName
            }
        }
    }
    
    func subjectWasChosen(_ newSubject: Subject) {
        print("elegido")
        subjectButton.setTitle(newSubject.name, for: .normal)
        subjectButton.tintColor = newSubject.color
        subject = newSubject
        if let _ = userTask {
            userTask!.subject = newSubject
        }
    }
}

extension AddTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userTask = userTask, let subtasks = userTask.subtasks {
            return subtasks.count
        } else if let subtasks = subtasks {
            return subtasks.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Borrar") { (action, view, completion) in
            if let _ = self.userTask?.subtasks?[indexPath.row]{
                self.userTask?.subtasks?.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        delete.backgroundColor =  UIColor(named: "DestructiveColor")
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtaskCell") as? UserSubtaskTableViewCell
        if let subtask = userTask?.subtasks?[indexPath.row] {
            cell?.subtaskNameTextField.text = subtask.name
            cell?.subtaskTextDelegate = self
            cell?.subtaskDoneDelegate = self
            if userIsEdditing {
                cell?.subtaskNameTextField.isEnabled = true
            } else {
                cell?.subtaskNameTextField.isEnabled = false
            }
            if subtask.done {
                cell?.doneButton.setImage(Constants.subTaskDoneImage, for: .normal)
                cell?.subtaskDone = true
            } else {
                cell?.doneButton.setImage(Constants.subTaskUndoneImage, for: .normal)
                cell?.subtaskDone = false
            }
        } else {
            cell?.subtaskTextDelegate = self
            cell?.subtaskDoneDelegate = self
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
