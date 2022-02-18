//
//  TasksViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 14/1/22.
//

import UIKit

class TasksListController: UITableViewController {

    var userTasks: [PTTask]?
    var subjects: [PTSubject]?

    @IBOutlet var tasksTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Mock data
        subjects = [PTSubject(name: "iOS", color: .red), PTSubject(name: "Acceso a datos", color: .blue), PTSubject(name: "ingles", color: .green)]
        userTasks = MockUser.user.tasks
    }
    
            
    override func viewWillAppear(_ animated: Bool) {
        print("appearing")
        tasksTableView.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskDetail" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as? AddTaskViewController
                controller?.userTask = userTasks![indexpath.row]
                print("ok")
            }
        }
    }
   
    @IBAction func addNewTask(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NewTask") as? AddTaskViewController {
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - TableView Extension
extension TasksListController: SaveNewTaskProtocol, TaskCellDoneDelegate {
    func taskDonePushed(_ taskCell: UserTaskTableViewCell, taskDone: Bool?) {
        let indexPath = tasksTableView.indexPath(for: taskCell)
        if let row = indexPath?.row, let _ = userTasks,  let done = taskDone {
            userTasks![row].completed = done
        }
    }
    
    func appendNewTask(newTask: PTTask) {
        if let _ = userTasks {
            userTasks!.append(newTask)
        } else {
            userTasks = [newTask]
        }
    }
}
extension TasksListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tasks = userTasks {
            return tasks.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTaskDetail", sender: tableView.cellForRow(at:indexPath))
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         
            let delete = UIContextualAction(style: .normal, title: "Borrar") { (action, view, completion) in
                if let _ = self.userTasks {
                    self.userTasks?.remove(at: indexPath.row)
                }
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            delete.backgroundColor =  UIColor(named: "DestructiveColor")
        
            let edit = UIContextualAction(style: .normal, title: "Editar") { (action, view, completion) in
                self.performSegue(withIdentifier: "showTaskDetail", sender: indexPath)
                print(indexPath)
                completion(false)
            }
            edit.backgroundColor =  UIColor(named: "MainColor")
            let config = UISwipeActionsConfiguration(actions: [delete, edit])
            config.performsFirstActionWithFullSwipe = false
            return config
        }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! UserTaskTableViewCell
        if let task = userTasks?[indexPath.row] {
            cell.taskNameLabel.text = task.name
            cell.taskDone = task.completed
            cell.taskDoneDelegate = self
            if task.completed {
                cell.doneButton.setImage(Constants.taskDoneImage, for: .normal)
            } else {
                cell.doneButton.setImage(Constants.taskUndoneImage, for: .normal)
            }
            if let date = task.startDate{
                cell.taskDueDateLabel.text = date.formatted(date: .long, time: .omitted)
            }
            // TODO: Pensar manera de diferenciar asignaturas
            cell.courseColorImage.backgroundColor = task.subject?.color
        }
        return cell
    }
}

