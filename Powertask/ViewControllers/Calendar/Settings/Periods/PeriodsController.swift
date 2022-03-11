//
//  PeriodsController.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 2/2/22.
//
import UIKit

class PeriodsController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var period: [PTPeriod]?
    var deleteindexpath: IndexPath?
    var actualPeriod: [PTPeriod]?
    var previousPeriod: [PTPeriod]?
    var indexPeriod: Int?
    @IBOutlet var periodsTableView: UITableView!
    let confirmationAction = UIAlertController(title: "¿Estás seguro? Esta operación es irreversible", message: nil, preferredStyle: .actionSheet)
    override func viewDidLoad() {
        super.viewDidLoad()
        periodsTableView.dataSource = self
        periodsTableView.delegate = self
        actualPeriod = getActualPeriods(periods: PTUser.shared.periods)
        previousPeriod = getPastPeriods(periods: PTUser.shared.periods)
    
        confirmationAction.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            _ = self.periodsTableView.indexPathForSelectedRow
            self.deleteRow(deleteindexpath: self.deleteindexpath!)
            
        }))
        confirmationAction.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    }
    
    func getActualPeriods(periods: [PTPeriod]?) -> [PTPeriod]? {
        return period?.filter({ period in DateInterval(start: period.startDate, end: period.endDate).contains(Date.now) })
    }
    
    func getPastPeriods(periods: [PTPeriod]?) -> [PTPeriod]? {
        return period?.filter({ period in !DateInterval(start: period.startDate, end: period.endDate).contains(Date.now) })
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let actualPeriod = actualPeriod {
                return actualPeriod.count
            } else {
                return 0
            }
        }else if section == 1{
            if let previousPeriod = previousPeriod {
                return previousPeriod.count
            } else {
                return 0
            }
        }
        return 0
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.section == 0{
             performSegue(withIdentifier: "showPeriodDetail", sender: actualPeriod![indexPath.row])
         }else if indexPath.section == 1{
             performSegue(withIdentifier: "showPeriodDetail", sender: previousPeriod![indexPath.row])
         }
         
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let period = period?[indexPath.row]
         indexPeriod = indexPath.row
         let cell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath) as! PeriodsTableViewCell
             if indexPath.section == 0{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath) as! PeriodsTableViewCell
                 if let name = actualPeriod?[indexPath.row].name{
                     cell.periodName.text = name
                 }
                 return cell
             }

             if indexPath.section == 1{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath) as! PeriodsTableViewCell
                 if let name = previousPeriod?[indexPath.row].name{
                     cell.periodName.text = name
                 }
                 return cell
             }
        return cell
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         
            let delete = UIContextualAction(style: .normal, title: "Borrar") { (action, view, completion) in
                if let _ = self.period {
                    self.present(self.confirmationAction, animated: true, completion: nil)
                    self.deleteindexpath = indexPath
                }
                
            }
            delete.backgroundColor =  UIColor.systemRed
        
            let config = UISwipeActionsConfiguration(actions: [delete])
            config.performsFirstActionWithFullSwipe = false
         
            return config
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var name = ""
        switch (section){
            case 0:
                name = "Periodos Actuales"
                break
            case 1:
                name = "Otros periodos"
                break
            default:
                name = ""
                break
        }
        return name
    }
    
    func deleteRow (deleteindexpath: IndexPath){
        self.period?.remove(at: deleteindexpath.row)
        self.periodsTableView.deleteRows(at: [deleteindexpath], with: .left)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPeriodDetail" {
            if let indexpath = periodsTableView.indexPathForSelectedRow {
                let controller = segue.destination as? AddPeriodController
                controller?.userIsEditing = true
                controller?.period = sender as? PTPeriod
            }
        }
    }
    
    @IBAction func newPeriod(_ sender: UIButton) {
        performSegue(withIdentifier: "showPeriodDetail", sender: Any?.self)
    }
    
    
    
}
