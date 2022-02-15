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
    override func viewDidLoad() {
        super.viewDidLoad()
//        subjectsCollection.dragDelegate = self
//        subjectsCollection.dropDelegate = self
        // timeTable.dropDelegate = self
        subjectsCollection.dragInteractionEnabled = true
        subjectsCollection.dataSource = self
        //timeTable.dragInteractionEnabled = true
        subjects = MockUser.user.subjects
    }
    


}

//extension TimeTableViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        //
//    }
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//    }
//}
//
//extension TimeTableViewController: UITableViewDropDelegate {
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//        //
//    }
//}

extension TimeTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let subjects = subjects {
             return subjects.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let subjects = subjects, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCollectionCell", for: indexPath) as? SubjectCollectionViewCell {
            cell.subjectName.text = subjects[indexPath.row].name
            cell.subjectBackground.backgroundColor = subjects[indexPath.row].color
            cell.backgroundColor = UIColor.red
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
}
