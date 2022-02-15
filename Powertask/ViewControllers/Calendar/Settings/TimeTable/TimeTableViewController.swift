//
//  TimeTableViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import UIKit

class TimeTableViewController: UIViewController {

    @IBOutlet weak var timeTable: UITableView!
    @IBOutlet weak var subjectsCollection: UICollectionView!
    var subjects: [Subject]?
    var colors: [UIColor]?
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectsCollection.dragDelegate = self
        subjectsCollection.dropDelegate = self
        // timeTable.dropDelegate = self
        subjectsCollection.dragInteractionEnabled = true
        subjectsCollection.dataSource = self
        timeTable.dataSource = self
        timeTable.delegate = self
        subjects = MockUser.user.subjects
        colors = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.blue]
    }
    


}

extension TimeTableViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("soltado")
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        //if let subjects = subjects {
        print("cogido")
            let item = colors![indexPath.row]
            let itemProvider = NSItemProvider(object: item as UIColor)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        //}
    }
    
}

extension TimeTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let subjects = colors {
             return subjects.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let subjects = subjects, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCollectionCell", for: indexPath) as? SubjectCollectionViewCell {
            cell.subjectBackground.backgroundColor = colors![indexPath.row]
//            cell.subjectName.text = subjects[indexPath.row].name
//            cell.subjectBackground.backgroundColor = subjects[indexPath.row].color
//            cell.subjectBackground.layer.cornerRadius = 10
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension TimeTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Lunes"
        case 1:
            return "Martes"
        case 2:
            return "Miercoles"
        case 3:
            return "Jueves"
        case 4:
            return "Viernes"
        case 5:
            return "Sábado"
        case 6:
            return "Domingo"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "timeBlockCell", for: indexPath) as? TimeTableTableViewCell {
            cell.subjectDropZone.backgroundColor = UIColor.gray
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

