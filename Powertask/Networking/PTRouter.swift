//
//  PTRouter.swift
//  Powertask
//
//  Created by Daniel Torres on 28/2/22.
//

import UIKit
import Alamofire

enum PTRouter {
    case login
    case listSubjects
    case editSubject(PTSubject)
    
    case listTasks
    case createTask(PTTask)
    case editTask(PTTask)
    case deleteTask(PTTask)
    case toogleTask(PTTask)
    case toogleSubtask(PTSubtask)
    
    case listEvents
    case createEvent(PTEvent)
    case editEvent(PTEvent)
    case deleteEvent(PTEvent)
    
    case listPeriods
    case createPeriod(PTPeriod)
    case editPeriod(PTPeriod)
    case deletePeriod(PTPeriod)
    
    case listBlocks(PTPeriod)
    case createBlock(PTBlock)
    case editBlock(PTBlock)
    case deleteBlock(PTBlock)
    
    case listSessions
    case createSession(PTSession)
    case deleteSession(PTSession)

  var baseURL: String {
      return "http://powertask.kurokiji.com/public/api"
  }

  var path: String {
    switch self {
    case .login:
        return "/loginRegister"
    case .listSubjects:
        return "/subject/list"
    case .editSubject(let subject):
        return "/task/edit/\(subject.id)"
    
    case .listTasks:
        return "/task/list"
    case .createTask:
        return "/task/create"
    case .editTask(let task):
        return "/task/edit/\(task.id)"
    case .deleteTask(let task):
        return "/task/delete/\(task.id)"
    case .toogleTask(let task):
        return "/task/toggle/\(task.id)"
    case .toogleSubtask(let subtask):
        return "/subtask/toggle/\(subtask.id)"
   
    case .listEvents:
        return "/event/list"
    case .createEvent(let event):
        return "/event/create"
    case .editEvent(let event):
        if let eventId = event.id {
            return "/event/edit/\(eventId)"
        } else {
            return "/event/edit/"
        }
    case .deleteEvent(let event):
        if let eventId = event.id {
            return "/event/delete/\(eventId)"
        } else {
            return "/event/delete/"
        }
    case .listPeriods:
        return "/period/list"
    case .createPeriod:
        return "/period/create"
    case .editPeriod(let period):
        return "/period/edit/\(period.id)"
    case .deletePeriod(let period):
        return "/period/delete/\(period.id)"
    
    case .listBlocks(let period):
        return "/block/list/\(period.id)"
    case .createBlock:
        return "/block/create"
    case .editBlock(let block):
        return "/block/edit/\(block.id)"
    case .deleteBlock(let block):
        return "/block/edit/\(block.id)"
   
    case .listSessions:
        return "/session/list"
    case .createSession:
        return "/session/create"
    case .deleteSession(let session):
        return "/session/delete/\(session.id)"
    }
  }

  var method: HTTPMethod {
    switch self {

    case .login, .editSubject(_), .editTask(_), .toogleTask(_), .toogleSubtask(_), .editEvent(_), .editPeriod(_), .editBlock(_):
        return .put
    case .listSubjects, .listTasks, .listEvents, .listPeriods, .listBlocks(_), .listSessions:
        return .get
        
    case .createTask(_), .createEvent(_), .createPeriod(_), .createBlock(_), .createSession(_):
        return .post
    case .deleteTask(_), .deleteEvent(_), .deletePeriod(_), .deleteBlock(_), .deleteSession(_):
        return .delete
    }
  }

  var parameters: [String: String]? {
    switch self {
    case .login, .listSubjects, .deleteTask(_), .listTasks, .toogleTask(_), .toogleSubtask(_), .listEvents, .deleteEvent(_), .listPeriods, .deletePeriod(_), .listBlocks(_), .deleteBlock(_), .listSessions, .deleteSession(_):
        return nil
        
    case .editSubject(let subject):
        return ["name" : subject.name ?? "" , "color" : subject.color ?? "#000000"]
        
 
    case .createTask(let task), .editTask(let task):
        if let subjectId = task.subject?.id {
            return ["name" : task.name,
                    "date_start" : "fecha de prueba",
                    "description" : task.description ?? "",
                    "subject_id" : String(subjectId)]
        } else {
            return ["name" : task.name,
                    "date_start" : "fecha de prueba",
                    "description" : task.description ?? ""]
        }
        
    case .createEvent(let event), .editEvent(let event):
        if let subjectId = event.subject?.id {
            return ["name": event.name,
                    "type": event.type.rawValue,
                    "all_day" : String(event.allDay),
                    "timestamp_start": String(event.startDate.timeIntervalSince1970),
                    "timestamp_end": String(event.endDate.timeIntervalSince1970),
                    "subject_id": String(subjectId)
            ]
        } else {
            return ["name": event.name,
                    "type": event.type.rawValue,
                    "all_day" : String(event.allDay),
                    "timestamp_start": String(event.startDate.timeIntervalSince1970),
                    "timestamp_end": String(event.endDate.timeIntervalSince1970),
            ]
        }
    
    case .createPeriod(let period), .editPeriod(let period):
        return ["name": period.name,
                "date_start": String(period.startDate.timeIntervalSince1970),
                "date_end": String(period.endDate.timeIntervalSince1970),
        ]

    case .createBlock(let block), .editBlock(let block):
        return ["time_start": String(block.timeStart.timeIntervalSince1970),
                "time_end": String(block.timeEnd.timeIntervalSince1970),
                "day": String(block.day),
                "subject_id": String(block.subject.id!)
        ]

    case .createSession(let session):
        if let taskId = session.task?.id {
            return ["quantity": String(session.quantity),
                    "duration": String(session.duration),
                    "total_time": String(session.duration),
                    "task_id": String(taskId),
            ]
        } else {
            return ["quantity": String(session.quantity),
                    "duration": String(session.duration),
                    "total_time": String(session.duration),
            ]
        }
    }
  }
}

extension PTRouter: URLRequestConvertible {
  func asURLRequest() throws -> URLRequest {
    let url = try baseURL.asURL().appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method
    if method == .get {
      request = try URLEncodedFormParameterEncoder()
        .encode(parameters, into: request)
    } else if method == .post || method == .put {
      request = try JSONParameterEncoder().encode(parameters, into: request)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    return request
  }
}

