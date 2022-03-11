//
//  MockData.swift
//  Powertask
//
//  Created by Daniel Torres on 15/2/22.
//

import Foundation
import UIKit

class MockUser {
   static var course = PTCourse(id: 2, name: "Primero de Apps")
//    static  var subjects = [PTSubject(name: "iOS", color: "#234343"),
//                            PTSubject(name: "Acceso a datos", color: "#453654"),
//                            PTSubject(name: "Inglés", color: "#987584"),
//                    PTSubject(name: "Scrum", color: "#543233"),
//                    PTSubject(name: "Proyecto", color: "#346578"),
//                    PTSubject(name: "Empresa", color: "#342454")]
    
//   static var periods = [PTPeriod(name: "Primer trimestre", startDate: Date(timeIntervalSince1970: 1631232000), endDate: Date(timeIntervalSince1970: 1640131200)),
//                   PTPeriod(name: "Segundo trimestre", startDate: Date(timeIntervalSince1970: 1641772800), endDate: Date(timeIntervalSince1970: 1648166400)),
//                   PTPeriod(name: "Tercer trimestre", startDate: Date(timeIntervalSince1970: 1648771200), endDate: Date(timeIntervalSince1970: 1656374400))]
    
//   static var exams = [PTEvent(id: 1, name: "Examen de acceso", type: EventType.exam, allDay: false, startDate: Date(timeIntervalSince1970: 1646043120), endDate: Date(timeIntervalSince1970: 1646046720), subject: subjects[0], notes: "Pruebas de notas del examen de acceso"),
//                       PTEvent(id: 2, name: "Examen de Empresa", type: EventType.exam, allDay: false, startDate: Date(timeIntervalSince1970: 1646133120), endDate: Date(timeIntervalSince1970: 1646137800), subject: subjects[1], notes: "Notas del examen 2")]
//
//
//    static var days = [["pe" : PTDay(vacation: nil, exam: [PTEvent(id: 1, name: "Examen de acceso", type: EventType.exam, allDay: false, startDate: Date(timeIntervalSince1970: 1645617600), endDate: Date(timeIntervalSince1970: 1645621200), subject: subjects[0], notes: "Pruebas de notas del examen de acceso")], personal: [PTEvent(id: 5, name: "Dentista", type: EventType.personal, allDay: false, startDate: Date(timeIntervalSince1970: 1645617600), endDate: Date(timeIntervalSince1970: 1645621200), subject: nil, notes: "Llevar ferula")])], ["pe" : PTDay(vacation: [PTEvent(id: 3, name: "San Isidro", type: EventType.vacation, allDay: true, startDate: Date(timeIntervalSince1970: 1645660800), endDate: Date(timeIntervalSince1970: 1645747140), subject: nil, notes: nil)], exam: [], personal: [PTEvent(id: 5, name: "Cara dura", type: EventType.personal, allDay: false, startDate: Date(timeIntervalSince1970: 1645718400), endDate: Date(timeIntervalSince1970: 1645720380), subject: nil, notes: "Llevar ferula")])]]
//
//    static var blocks = [PTBlock(id: 1, timeStart: Date(timeIntervalSince1970: 946731600), timeEnd: Date(timeIntervalSince1970: 946737000), day: 1, subject: subjects[0]), PTBlock(id: 2, timeStart: Date(timeIntervalSince1970: 946740600), timeEnd: Date(timeIntervalSince1970: 946744200), day: 7, subject: subjects[1]), PTBlock(id: 1, timeStart: Date(timeIntervalSince1970: 946731600), timeEnd: Date(timeIntervalSince1970: 946737000), day: 3, subject: subjects[0]), PTBlock(id: 2, timeStart: Date(timeIntervalSince1970: 946740600), timeEnd: Date(timeIntervalSince1970: 946744200), day: 5, subject: subjects[3])]
//
//    static var vacation = [PTEvent(id: 3, name: "San Isidro", type: EventType.vacation, allDay: true, startDate: Date(timeIntervalSince1970: 1646352000), endDate: Date(timeIntervalSince1970: 1646438340), subject: nil, notes: nil), PTEvent(id: 4, name: "Festivo especial", type: EventType.vacation, allDay: true, startDate: Date(timeIntervalSince1970: 1644796800), endDate: Date(timeIntervalSince1970: 1645055940), subject: nil, notes: nil)]
//
//    static var personal = [PTEvent(id: 5, name: "Dentista", type: EventType.personal, allDay: false, startDate: Date(timeIntervalSince1970: 1645027200), endDate: Date(timeIntervalSince1970: 1645029000), subject: nil, notes: "Llevar ferula"),
//                           PTEvent(id: 6, name: "Días libres", type: EventType.personal, allDay: false, startDate: Date(timeIntervalSince1970: 1645272000), endDate: Date(timeIntervalSince1970: 1645632000), subject: nil, notes: "Yuhiiii")]
    
//    static var events = PTDay(vacation: personal, exam: exams, personal: vacation)
    
    // las tareas y los eventos tienen que devolver el id al crearlos en el servidor
    
//    static var tasks = [PTTask(googleId: nil, studentId: 1, id: 1, completed: false, name: "Ejercicio 1", subject: subjects[0], description: "Descripción", mark: nil, handoverDate: nil, startDate: nil, subtasks: nil), PTTask(googleId: 3, studentId: 1, id: 3, completed: false, name: "Prueba", subject: subjects[0], description: "Descripcion de tarea", mark: nil, handoverDate: Date(timeIntervalSince1970: 1645632000), startDate: Date(timeIntervalSince1970: 1645200000), subtasks: [PTUserSubtask(name: "prueba", done: false), PTUserSubtask(name: "Prueba 2", done: true)])]
//    
   // static var sessions = [PTSession(id: 1, quantity: 3, duration: 4, task: nil)]
    
//    static var user = PTUser(id: 1, name: "Daniel", email: "prueba@cev.com", imageUrl: "asdfgfh", course: course, subjects: subjects, periods: periods, blocks: blocks, events: days, tasks: nil, sessions: sessions)
}
