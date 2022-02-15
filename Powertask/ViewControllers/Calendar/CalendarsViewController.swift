//
//  CalendarsViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 14/1/22.
//

import UIKit
import FSCalendar
import EventKit

class CalendarsViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var eventListTable: UITableView!
    @IBOutlet weak var addEventPullDownButton: UIButton!
    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    var selectedDateEvents: [Event]?
    let eventStore = EKEventStore()
    var events = [Event(name: "Examen 1",
                        type: EventType.exam,
                        startDate: Date.now,
                        subject: Subject(name: "iOS", color: .purple)),
                  Event(name: "Evento Personal 1",
                        type: EventType.personal,
                        startDate: Date.now.addingTimeInterval(234),
                        endDate: Date.now.addingTimeInterval(456)),
                  Event(name: "San Isidro",
                        type: EventType.vacation,
                        startDate: Date.now.addingTimeInterval(214),
                        endDate: Date.now.addingTimeInterval(234)),
                  Event(name: "Día de la Almudena", type: EventType.vacation, startDate: Date.now.addingTimeInterval(20343), subject: Subject(name: "Acceso a datos", color: .systemIndigo)),
                  Event(name:"Examen de mates", type: EventType.exam, startDate: Date.now.addingTimeInterval(86400), subject: Subject(name: "Acceso a datos", color: .green)),
                  Event(name: "Examen 2",
                                      type: EventType.exam,
                                      startDate: Date.now.addingTimeInterval(8640),
                        subject: Subject(name: "iOS", color: .orange)),
                    Event(name: "Evento Personal 2",
                          type: EventType.personal,
                          startDate: Date.now,
                          endDate: Date.now.addingTimeInterval(202830)),
                    Event(name: "Festivo 2",
                          type: EventType.vacation,
                          startDate: Date.now.addingTimeInterval(172900),
                          endDate: Date.now.addingTimeInterval(173000))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDateEvents = getEventForDate(date: Date.now, events: events)
        eventStore.requestAccess(to: .event) { success, error in
            if success, error == nil {
                print("autorizado")
                
            }
        }
        calendarView.delegate = self
        calendarView.dataSource = self
        eventListTable.delegate = self
        eventListTable.dataSource = self
        calendarView.locale = Locale(identifier: "es")
        calendarView.appearance.headerTitleFont = UIFont.preferredFont(forTextStyle: .title1)
        calendarTitle.text = calendarView.currentPage.addingTimeInterval(43200).formatToString(using: .monthYear)
        swipeAction()
        // TODO: Convertir titulo a boton para volver a la pagina de la fecha actual
        //calendarView.calendarHeaderView.isHidden = true
//        calendarView.appearance.headerTitleAlignment = .left
//        calendarView.appearance.headerTitleFont = UIFont.preferredFont(forTextStyle: .headline).withSize(30)
//        calendarView.appearance.headerDateFormat = "MMMM 'de' Y"
//        calendarView.appearance.headerTitleColor
        // Cambiar a vista de semana, como se hace?
        // calendarView.scope = .week
    
        // USO DE EKEVENTS
//        let eventStore = EKEventStore()
//        let event = EKEvent(eventStore: eventStore)
//        event.title = "prueba"
//        event.startDate = Date.now
//        event.endDate = Calendar.current.date(byAdding: .day, value: 4, to: Date.now)
//        event.notes = "Prueba de notas"
//
    
        // TODO: Pasar esto a una función
        let eventMenu = UIAction(title: "Examen", image: UIImage(systemName: "doc.plaintext")) { (action) in
            self.instantiateNewEventController(eventType: EventType.exam, isNewEvent: true, event: nil)
        }
        
        let vacationMenu = UIAction(title: "Festivo", image: UIImage(systemName: "heart")) { (action) in
            self.instantiateNewEventController(eventType: EventType.vacation, isNewEvent: true, event: nil)
        }
        
        let personalMenu = UIAction(title: "Personal", image: UIImage(systemName: "person")) { (action) in
            self.instantiateNewEventController(eventType: EventType.personal, isNewEvent: true, event: nil)
        }
        
        let menu = UIMenu(title: "Nuevo evento", options: .displayInline, children: [eventMenu, vacationMenu, personalMenu])
        addEventPullDownButton.menu = menu
        addEventPullDownButton.showsMenuAsPrimaryAction = true
    }
    
    func instantiateNewEventController(eventType: EventType, isNewEvent: Bool, event: Event?) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "newEventView") as? NewEventViewController {
                   //vc.delegate = self
            viewController.isNewEvent = isNewEvent
            viewController.eventType = eventType
            if let event = event {
                viewController.event = event
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
    func getEventForDate(date: Date, events: [Event]) -> [Event]{
        let selectedEvents = events.filter { event in
            // si el dia de hoy esta entre inicio y fin, devuelvo el evento
            if let endDate = event.endDate {
                print("nombre: \(event.name) fecha de inicio: \(event.startDate) fecha de fin: \(endDate) fecha actual: \(date)")
                return DateInterval(start: event.startDate, end: endDate).contains(date)
            }
            return event.startDate.formatToString(using: .justDay) == date.formatToString(using: .justDay)
        }
        return selectedEvents.sorted { event1, event2 in
            if event1.type == event2.type {
                return event1.startDate > event2.startDate
            }
            return event1.type > event2.type
        }
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
}

// MARK:- Calendar Delegate and DataSource
extension CalendarsViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("fecha selccionada \(date.formatToString(using: .justDay))")
        selectedDateEvents = getEventForDate(date: date, events: events)
        eventListTable.reloadSections([0,0], with: .fade)
        print("En la fecha \(date) hay \(selectedDateEvents)")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
       // print(getEventForDate(date: date, events: events).count)
        return getEventForDate(date: date, events: events).count
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
        let thisDateEvents = getEventForDate(date: date, events: events)
        var colors: [UIColor] = []
        let examnEvents = thisDateEvents.filter { event in
            event.type == EventType.exam
        }
        let personalEvents = thisDateEvents.filter { event in
            event.type == EventType.personal
        }
//        let vacationEvents = thisDateEvents.filter { event in
//            event.type == EventType.vacation
//        }
        // TODO: Cambiar los colores a los del sistema cuando tengas el git reparado
        for exam in examnEvents {
            if let color = exam.subject?.color {
                colors.append(color)
            }
        }
//        for _ in vacationEvents {
//            colors.append(UIColor.blue)
//        }
        for _ in personalEvents {
            colors.append(UIColor.lightGray)
        }
        return colors
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 2.2)
    }
}

// MARK:- TableView Delegate and DataSource
extension CalendarsViewController: UITableViewDelegate, UITableViewDataSource {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date.formatToString(using: .justDay) == Date.now.formatToString(using: .justDay) {
            return UIColor.white
        }
        let events = getEventForDate(date: date, events: events)
        for event in events {
            if event.type == EventType.vacation {
                return UIColor.red
            }
        }
        return UIColor.black
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let events = selectedDateEvents else { return 0 }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        //TODO: Buscar un color de selección
        backgroundView.backgroundColor = UIColor(named: "AccentColor")
        guard let event = selectedDateEvents?[indexPath.row] else { return UITableViewCell() }
        // TODO: Si es tarea?
        switch event.type {
        case .vacation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "allDayRow") as? AllDayEventTableViewCell
            cell?.selectedBackgroundView = backgroundView
            cell?.eventColorImage.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(CGFloat(0.6))
            cell?.eventNameLabel.text = event.name
            return cell!
        case .exam, .personal:
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventRow") as? EventTableViewCell
            cell?.selectedBackgroundView = backgroundView
            cell?.eventTitle.text = event.name
//            cell?.eventStartDate.text = event.startDate.formatted(.dateTime.hour().minute())
//            if event.endDate != nil {
//                cell?.eventEndDate.text = event.endDate!.formatted(.dateTime.hour().minute())
//            } else {
//                cell?.untilLabel.isHidden = true
//                cell?.eventEndDate.isHidden = true
//            }
            cell?.eventColor.backgroundColor = event.subject?.color
            return cell!
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
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = selectedDateEvents?[indexPath.row] {
            switch event.type {
            case EventType.personal:
                instantiateNewEventController(eventType: EventType.personal, isNewEvent: false, event: event)
            case EventType.exam:
                instantiateNewEventController(eventType: EventType.exam, isNewEvent: false, event: event)
            case EventType.vacation:
                instantiateNewEventController(eventType: EventType.vacation, isNewEvent: false, event: event)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- Date Extensions
extension DateFormatter {
   static let monthYear: DateFormatter = {
      let formatter = DateFormatter()
      formatter.timeZone = TimeZone(abbreviation: "GMT")
      formatter.dateFormat = "MMMM 'de' Y"
      return formatter
   }()
    
    static let justDay: DateFormatter = {
        let formatter = DateFormatter()
        //formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "d M Y"
        return formatter
    }()
}

extension Date {
   func formatToString(using formatter: DateFormatter) -> String {
      return formatter.string(from: self)
   }
}
