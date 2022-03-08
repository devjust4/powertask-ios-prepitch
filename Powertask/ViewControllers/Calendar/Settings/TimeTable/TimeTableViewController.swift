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
    var subjects: [PTSubject]?
    var blocks:  [Int : [PTBlock]]?
    var colors: [UIColor]?
    let weekDays = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sábado", "Domingo"]
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectsCollection.dragDelegate = self
        subjectsCollection.dragInteractionEnabled = true
        subjectsCollection.dataSource = self
        timeTable.dataSource = self
        timeTable.delegate = self
        //subjects = MockUser.user.subjects
        //blocks = filterAllBlocks(blocks: MockUser.user.blocks)
        var currentPeriod: PTPeriod?
        if let periods = PTUser.shared.periods {
            currentPeriod = periods.first(where: { period in
                period.startDate > Date.now && period.endDate < Date.now
            })
        }
        if let currentPeriod = currentPeriod {
            NetworkingProvider.shared.listBlocks(period: currentPeriod) { blocks in
                PTUser.shared.blocks = blocks
            } failure: { msg in
                print("error")
            }

        }
        
        NetworkingProvider.shared.listSubjects() { subjects in
            PTUser.shared.subjects = subjects
            self.blocks = self.filterAllBlocks(blocks: PTUser.shared.blocks)
            self.timeTable.reloadData()
            self.subjectsCollection.reloadData()
        } failure: { error in
            print(error)
        }
        
    }
    
    func filterBlockByDay(blocks: [PTBlock] ,weekDay: Int) -> [PTBlock]{
        return blocks.filter { block in
            block.day == weekDay
        }
    }
    
    func filterAllBlocks(blocks: [PTBlock]?) -> [Int : [PTBlock]]? {
        if let blocks = blocks {
            let monday = filterBlockByDay(blocks: blocks, weekDay: 1)
            let thuesday = filterBlockByDay(blocks: blocks, weekDay: 2)
            let wednesday = filterBlockByDay(blocks: blocks, weekDay: 3)
            let tursday = filterBlockByDay(blocks: blocks, weekDay: 4)
            let friday = filterBlockByDay(blocks: blocks, weekDay: 5)
            let saturday = filterBlockByDay(blocks: blocks, weekDay: 6)
            let sunday = filterBlockByDay(blocks: blocks, weekDay: 7)
            return [0 : monday, 1 : thuesday, 2 : wednesday, 3 : tursday, 4 : friday, 5 : saturday, 6 : sunday]
        } else {
            return [0 : [], 1 : [], 2 : [], 3 : [], 4 : [], 5 : [], 6 : []]
        }
    }
}

extension TimeTableViewController: UICollectionViewDragDelegate {
    // Codifica el elemento seleccionado para poder ser arrastrado
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let subjects = PTUser.shared.subjects else {
            // TODO: Esto no es muy elegante. Pensar soluciones
            return [UIDragItem(itemProvider: NSItemProvider())]
        }
        let item = subjects[indexPath.row]
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
}

extension TimeTableViewController: UICollectionViewDataSource {
    // Cuenta el número de asignaturas y se lo pasa a la colección
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let subjects = PTUser.shared.subjects {
             return subjects.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // carga cada una de las celdas con la info necesaria
        if let subjects = PTUser.shared.subjects, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCollectionCell", for: indexPath) as? SubjectCollectionViewCell {
            cell.subjectName.text = subjects[indexPath.row].name
            cell.subjectBackground.backgroundColor = UIColor(subjects[indexPath.row].color)
            cell.subjectBackground.layer.cornerRadius = 17
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension TimeTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weekDays[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // TODO: QUE ES ESTO?
        if let count = blocks?[section]?.count {
            return count + 1
            //+ 1
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "timeBlockCell", for: indexPath) as? TimeTableTableViewCell {
            cell.blockEditDelegate = self
            if let selectedBlocks = blocks?[indexPath.section], selectedBlocks.indices.contains(indexPath.row), let subject = selectedBlocks[indexPath.row].subject {
                let block = selectedBlocks[indexPath.row]
                cell.cellSubject = subject
                cell.startDatePicker.date = block.timeStart
                cell.endDatePicker.date = block.timeEnd
            } else {
                cell.setSubjectNil()
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension TimeTableViewController: TimeTableDelegate {
    func changeSubject(_ cell: TimeTableTableViewCell, newSubject: PTSubject) {
        if let indexPath = timeTable.indexPath(for: cell), let _ = blocks?[indexPath.section] {
                blocks![indexPath.section]![indexPath.row].subject = newSubject
        }
    }
    
    func changeBlockDate(_ cell: TimeTableTableViewCell, startDate: Date?, endDate: Date?) {
        //TODO: OJO! Revisar que el bloque existe
        if let indexPath = timeTable.indexPath(for: cell), let _ = blocks?[indexPath.section] {
            if let startDate = startDate {
                blocks![indexPath.section]![indexPath.row].timeStart = startDate
            }
            if let endDate = endDate {
                blocks![indexPath.section]![indexPath.row].timeEnd = endDate
                print(endDate)
            }
        }
    }
    
    func addNewBlock(_ cell: TimeTableTableViewCell, newSubject: PTSubject?) {
        if let indexPath = timeTable.indexPath(for: cell), let _ = blocks?[indexPath.section], let subject = newSubject {
            blocks?[indexPath.section]?.append(PTBlock(id: nil, timeStart: Date.now, timeEnd: Date.now, day: indexPath.section, subject: subject))
            timeTable.beginUpdates()
            timeTable.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
            timeTable.endUpdates()
        }
    }
    
    func deleteBlock(_ cell: TimeTableTableViewCell) {
        if let indexPath = timeTable.indexPath(for: cell), let _ = blocks?[indexPath.section]?[indexPath.row] {
           // blocks![indexPath.section]![indexPath.row].subject = nil
            blocks![indexPath.section]!.remove(at: indexPath.row)
            timeTable.beginUpdates()
            timeTable.deleteRows(at: [indexPath], with: .automatic)
            timeTable.endUpdates()
        }
    }
    
    
}
