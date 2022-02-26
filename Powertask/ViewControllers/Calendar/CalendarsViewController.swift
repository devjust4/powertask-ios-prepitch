//
//  CalendarsViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 14/1/22.
//

import UIKit
import FSCalendar
import EventKit
import UIColorHexSwift

class CalendarsViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var eventListTable: UITableView!
    @IBOutlet weak var addEventPullDownButton: UIButton!
    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    var selectedDateEvents: PTDay?
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedDateEvents = getEventForDate(date: Date.now, events: events)
//        eventStore.requestAccess(to: .event) { success, error in
//            if success, error == nil {
//                print("autorizado")
//
//            }
//        }
        PTUser.shared.apiToken = "$2y$10$2FOy9mkxyAq5AEfbz02gIO.IIhNN0sQ7hfas8/n0wEBQGpBfiuLI2"
        calendarView.delegate = self
        calendarView.dataSource = self
        eventListTable.delegate = self
        eventListTable.dataSource = self
        calendarView.locale = Locale(identifier: "es")
        //calendarView.appearance.headerTitleFont = UIFont.preferredFont(forTextStyle: .title1)
        calendarTitle.text = calendarView.currentPage.addingTimeInterval(43200).formatToString(using: .monthYear)
        swipeAction()
    
        // TODO: Convertir titulo a boton para volver a la pagina de la fecha actual
        calendarView.appearance.eventSelectionColor = UIColor.lightGray

        NetworkingProvider.shared.listEvents(apiToken: PTUser.shared.apiToken!) { events in
            PTUser.shared.events = events
            self.calendarView.reloadData()
            self.selectedDateEvents = self.getEventForDate(date: Date.now, events: PTUser.shared.events)
            self.eventListTable.reloadSections([0,1,2], with: .fade)
        } failure: { msg in
            print(msg)
        }

    
        // TODO: Pasar esto a una función
        let eventMenu = UIAction(title: "Examen", image: UIImage(systemName: "doc.plaintext")) { (action) in
            self.instantiateNewEventController(eventType: EventType.exam, event: nil, indexPath: nil)
        }
        
        let vacationMenu = UIAction(title: "Festivo", image: UIImage(systemName: "heart")) { (action) in
            self.instantiateNewEventController(eventType: EventType.vacation, event: nil, indexPath: nil)
        }
        
        let personalMenu = UIAction(title: "Personal", image: UIImage(systemName: "person")) { (action) in
            self.instantiateNewEventController(eventType: EventType.personal, event: nil, indexPath: nil)
        }
        
        let menu = UIMenu(title: "Nuevo evento", options: .displayInline, children: [eventMenu, vacationMenu, personalMenu])
        addEventPullDownButton.menu = menu
        addEventPullDownButton.showsMenuAsPrimaryAction = true
    }
    
    func instantiateNewEventController(eventType: EventType, event: PTEvent?, indexPath: IndexPath?) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "newEventView") as? NewEventViewController {
            viewController.delegate = self
            if indexPath == nil {
                viewController.isNewEvent = true
            } else {
                viewController.isNewEvent = false
                viewController.indexPath = indexPath
            }
            viewController.eventType = eventType
            if let event = event {
                viewController.event = event
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
    func getEventForDate(date: Date, events: [String: PTDay]?) -> PTDay?{
        guard let events = events else {  return nil  }
        // TODO: Arreglar los formatos de fecha servidor vs app
        var eventsForDate = events[String(format: "%.0f", date.timeIntervalSince1970 + 3600)]
        if let personalEvents = eventsForDate?.personal {
            var personal = personalEvents.sorted(by: { event1, event2 in
                if event1.all_Day == event2.all_Day {
                    return event1.startDate < event2.startDate
                }
                return event1.all_Day > event2.all_Day
            })
            eventsForDate?.personal = personal
        }
        return eventsForDate
    }
    
    func swipeAction() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendarView.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendarView.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            calendarView.setScope(.week, animated: true)
        case .down:
            calendarView.setScope(.month, animated: true)
        default:
            calendarView.setScope(.month, animated: true)
        }
    }
    
    func getCellInfo(allDay: Int, start: Double, end: Double) -> String{
        let startDate = Date(timeIntervalSince1970: start)
        let endDate = Date(timeIntervalSince1970: end)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd/MM/YY"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:MM"
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd/MM 'a las' HH:MM"
        
        if Bool(truncating: allDay as NSNumber) {
            return "Todo el día"
        } else {
            if dayFormatter.string(from: startDate) == dayFormatter.string(from: endDate) {
                return "\(timeFormatter.string(from: startDate)) hasta \(timeFormatter.string(from: endDate))"
            } else {
                return "\(dateTimeFormatter.string(from: startDate)) hasta \(dateTimeFormatter.string(from: endDate))"
            }
        }
    }
}

// MARK:- Calendar Delegate and DataSource
extension CalendarsViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // se seleciona un dia
        selectedDateEvents = getEventForDate(date: date, events: PTUser.shared.events)
        if let _ = PTUser.shared.events?[String(format: "%.0f", date.timeIntervalSince1970 + 3600)] {
            PTUser.shared.events![String(format: "%.0f", date.timeIntervalSince1970 + 3600)] = selectedDateEvents
        }
        eventListTable.reloadSections([0,1,2], with: .fade)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // devolver la suma de los eventos personales y examenes del dia seleccionado
        let day = getEventForDate(date: date, events: PTUser.shared.events)
        var count = 0
        if let personalEvents = day?.personal {
            count += personalEvents.count
        }
        
        if let exams = day?.exam {
            count += exams.count
        }
        return count
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarTitle.text = calendarView.currentPage.addingTimeInterval(43200).formatToString(using: .monthYear)
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarViewHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        // TODO: Si falla al cargar los puntos, revisar que el metodo de eventos cuenta con las fiestas pero los colores no
//        let thisDateEvents = getEventForDate(date: date, events: events)
        //
        var colors: [UIColor] = []
        let day = getEventForDate(date: date, events: PTUser.shared.events)
        if let exams = day?.exam {
            for exam in exams {
                //TODO: Cambiar el color al de la asignatura
                print(exam.name)
                if let stringColor = exam.subject?.color  {
                    colors.append(UIColor(stringColor))
                }
                
            }
        }
        
        if let personalEvents = day?.personal {
            for event in personalEvents {
                colors.append(UIColor(named: "AccentColor")!)
            }
        }
        return colors
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 1.3)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date.formatToString(using: .justDay) == Date.now.formatToString(using: .justDay) {
            return UIColor.white
        }
        let day = getEventForDate(date: date, events: PTUser.shared.events)
        if let vacations = day?.vacation {
            if !vacations.isEmpty {
                return UIColor.red
            }
        }
        return UIColor.black
    }
}

// MARK:- TableView Delegate and DataSource
extension CalendarsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedDateEvents = selectedDateEvents else { return 0 }
        var count = 0
        if section == 0, let examsEvents = selectedDateEvents.exam {
            count += examsEvents.count
        }
        
        if section == 1, let vacationEvents = selectedDateEvents.vacation {
            count += vacationEvents.count
        }
        
        if section == 2, let personalEvents = selectedDateEvents.personal {
            count += personalEvents.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        //TODO: Buscar un color de selección
        backgroundView.backgroundColor = UIColor(named: "AccentColor")
        guard let events = selectedDateEvents else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            if let exams = events.exam, !exams.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventRow") as? EventTableViewCell
                cell?.selectedBackgroundView = backgroundView
                cell?.eventTitle.text = exams[indexPath.row].name
                cell?.eventInfo.text = getCellInfo(allDay: exams[indexPath.row].all_Day, start:  exams[indexPath.row].startDate, end:  exams[indexPath.row].endDate)
                if let stringColor = exams[indexPath.row].subject?.color {
                    cell?.eventColor.backgroundColor = UIColor(stringColor)
                }
                return cell!
            }
        case 1:
            if let vacations = events.vacation, !vacations.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "allDayRow") as? AllDayEventTableViewCell
                cell?.selectedBackgroundView = backgroundView
                cell?.eventColorImage.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(CGFloat(0.6))
                cell?.eventNameLabel.text = vacations[indexPath.row].name
                cell?.eventNameLabel.textColor = UIColor.white
                cell?.eventImage.image = UIImage(systemName: "heart.fill")
                cell?.eventImage.tintColor = UIColor.white
                return cell!
            }
        case 2:
            if let personal = events.personal, !personal.isEmpty {
                if Bool(truncating: personal[indexPath.row].all_Day as NSNumber) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "allDayRow") as? AllDayEventTableViewCell
                    cell?.backgroundColor = UIColor(named: "AccentColor")
                    cell?.selectedBackgroundView = backgroundView
                    cell?.eventColorImage.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(CGFloat(0.6))
                    cell?.eventNameLabel.text = personal[indexPath.row].name
                    cell?.eventNameLabel.textColor = UIColor.white
                    cell?.eventImage.image = UIImage(systemName: "24.circle.fill")
                    cell?.eventImage.tintColor = UIColor.white
                    return cell!
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "eventRow") as? EventTableViewCell
                    cell?.selectedBackgroundView = backgroundView
                    cell?.eventTitle.text = personal[indexPath.row].name
                    cell?.eventInfo.text = getCellInfo(allDay: personal[indexPath.row].all_Day, start:  personal[indexPath.row].startDate, end:  personal[indexPath.row].endDate)
                    return cell!
                }
            }
        default:
            break
        }
        return UITableViewCell()
        
        // TODO: Si es tarea?
//        switch event.type {
//        case EventType.vacation.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "allDayRow") as? AllDayEventTableViewCell
//            cell?.selectedBackgroundView = backgroundView
//            cell?.eventColorImage.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(CGFloat(0.6))
//            cell?.eventNameLabel.text = event.name
//            return cell!
//        case EventType.exam.rawValue, EventType.personal.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "eventRow") as? EventTableViewCell
//            cell?.selectedBackgroundView = backgroundView
//            cell?.eventTitle.text = event.name
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "eventRow") as? EventTableViewCell
//            cell?.selectedBackgroundView = backgroundView
//            cell?.eventTitle.text = event.name
            
//            cell?.eventStartDate.text = event.startDate.formatted(.dateTime.hour().minute())
//            if event.endDate != nil {
//                cell?.eventEndDate.text = event.endDate!.formatted(.dateTime.hour().minute())
//            } else {
//                cell?.untilLabel.isHidden = true
//                cell?.eventEndDate.isHidden = true
//            }
        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as? EventTableViewCell
//        cell?.selectedBackgroundView = backgroundView
//        guard let events = selectedDateEvents else { return UITableViewCell() }
//        cell?.eventTitle.text = events[indexPath.row].name
//        cell?.eventStartDate.text = events[indexPath.row].startDate.formatted(.dateTime.hour().minute())
//        if events[indexPath.row].endDate != nil {
//            cell?.eventEndDate.text = events[indexPath.row].endDate?.formatted(.dateTime.hour().minute())
//        } else {
//            cell?.untilLabel.isHidden = true
//            cell?.eventEndDate.isHidden = true
//        }
//        cell?.eventColor.backgroundColor = events[indexPath.row].subject?.color
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let events = selectedDateEvents else { return }
        
        switch indexPath.section {
        case 0:
            instantiateNewEventController(eventType: EventType.exam, event: events.exam![indexPath.row], indexPath: indexPath)
        case 1:
            instantiateNewEventController(eventType: EventType.vacation, event: events.vacation![indexPath.row], indexPath: indexPath)
        case 2:
            instantiateNewEventController(eventType: EventType.personal, event: events.personal![indexPath.row], indexPath: indexPath)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CalendarsViewController: NewEventProtocol {
    func SaveNewEvent(eventTitle: String, startDate: Date?, endDate: Date?, subject: PTSubject?, notes: String?, eventType: EventType, indexpath: IndexPath?) {
        if let indexpath = indexpath {
            switch indexpath.section {
            case 0:
                selectedDateEvents?.exam?[indexpath.row].name = eventTitle
                if let doubleStartDate = startDate?.timeIntervalSince1970 {
                    selectedDateEvents?.exam?[indexpath.row].startDate = doubleStartDate
                }
                if let doubleEndDate = endDate?.timeIntervalSince1970 {
                    selectedDateEvents?.exam?[indexpath.row].endDate = doubleEndDate
                }
                selectedDateEvents?.exam?[indexpath.row].notes = notes
                selectedDateEvents?.exam?[indexpath.row].subject = subject
            case 1:
                selectedDateEvents?.vacation?[indexpath.row].name = eventTitle
                if let doubleStartDate = startDate?.timeIntervalSince1970 {
                    selectedDateEvents?.vacation?[indexpath.row].startDate = doubleStartDate
                }
                if let doubleEndDate = endDate?.timeIntervalSince1970 {
                    selectedDateEvents?.vacation?[indexpath.row].endDate = doubleEndDate
                }
                selectedDateEvents?.vacation?[indexpath.row].notes = notes
            case 2:
                selectedDateEvents?.personal?[indexpath.row].name = eventTitle
                if let doubleStartDate = startDate?.timeIntervalSince1970 {
                    selectedDateEvents?.personal?[indexpath.row].startDate = doubleStartDate
                }
                if let doubleEndDate = endDate?.timeIntervalSince1970 {
                    selectedDateEvents?.personal?[indexpath.row].endDate = doubleEndDate
                }
                selectedDateEvents?.personal?[indexpath.row].notes = notes
            default:
                print("nada")
            }
        } else {
            
        }
        
        if let doubleSelectedDate = calendarView.selectedDate?.timeIntervalSince1970, let _ = PTUser.shared.events?[String(format: "%.0f", doubleSelectedDate + 3600)] {
            PTUser.shared.events![String(format: "%.0f", doubleSelectedDate + 3600)] = selectedDateEvents
        }
    }
    
   
}
