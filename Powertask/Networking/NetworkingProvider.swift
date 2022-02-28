//
//  NetworkingProvider.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation
import Alamofire

class NetworkingProvider {
    static let shared = NetworkingProvider()
    private let kBaseUrl = "http://powertask.kurokiji.com/public/api/"
    let statusOk = 200...499
    
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        let networkLogger = PTRequestLogger()
        let interceptor = PTRequestInterceptor()
        return Session(configuration: configuration, interceptor: interceptor, eventMonitors: [networkLogger])
    }()
    
    // MARK: - Register Request
    func registerOrLogin(success: @escaping (_ token: String) -> (), failure: @escaping (_ error: String) ->()) {
        sessionManager.request(PTRouter.login).responseDecodable (of: SPTResponse.self) { response in
            if let token = response.value?.token {
                success(token)
            } else {
                failure("No token")
            }
        }
    }
    
    //MARK: - Subjects Request
    func listSubjects(success: @escaping (_ subjects: [PTSubject]) -> (), failure: @escaping (_ error: String) ->()) {
        sessionManager.request(PTRouter.listSubjects).responseDecodable (of: SPTResponse.self) { response in
            print(response.debugDescription)
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let subjects = response.value?.subjects {
                        success(subjects)
                    } else {
                        failure("There is a problem connecting to the server")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Student not found")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editSubject(subject: PTSubject, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
       sessionManager.request(PTRouter.editSubject(subject)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    success("Subject edited properly")
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator error")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Subject by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Task Requests
    public func listTasks(success: @escaping (_ tasks: [PTTask])->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.listTasks).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let tasks = response.value?.tasks {
                        success(tasks)
                    } else {
                        failure("There is a problem decoding data")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Student doesn't have tasks")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func createTask(task: PTTask, success: @escaping (_ taskId: Int)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.createTask(task)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let taskId = response.value?.id {
                        success(taskId)
                    } else {
                        failure("There's an error getting the task id")
                    }
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors")
                    }
                case 401:
                    failure("Invalid token.")
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editTask(task: PTTask, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.editTask(task)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        success(response)
                    } else {
                        failure ("There's an error edditing the task")
                    }
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Task by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteTask(task: PTTask, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
       sessionManager.request(PTRouter.deleteTask(task)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        success(response)
                    } else {
                        failure("Task deleted successfully.")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Task by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func toggleTask(task: PTTask, success: @escaping (_ taskCompleted: Bool)->(), failure: @escaping (_ msg: String?)->()) {
       sessionManager.request(PTRouter.toogleTask(task)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let taskCompleted = response.value?.response {
                        success((taskCompleted as NSString).boolValue)
                    } else {
                        failure("There's an error changing completion status")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Task by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Subtask Requests
    public func toggleSubtask(subtask: PTSubtask, success: @escaping (_ subtaskCompleted: Bool)->(), failure: @escaping (_ msg: String?)->(), subtaskID: Int) {
        sessionManager.request(PTRouter.toogleSubtask(subtask)).validate(statusCode: 200...600).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let subtaskCompleted = response.value?.response {
                        success((subtaskCompleted as NSString).boolValue)
                    } else {
                        failure("There's an error changing completion status")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        // "Task by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Event Request
    public func createEvent(apiToken: String, event: PTEvent, success: @escaping (_ id: Int)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.createEvent(event)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let id = response.value?.id {
                        success(id)
                    } else {
                        failure("There is a problem creating the event")
                    }
                case 401:
                    failure("Invalid token.")
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editEvent(apiToken: String, event: PTEvent, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.editEvent(event)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    success("Event edited properly.")
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors.")
                    }
                case 401:
                        failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Event by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteEvent(apiToken: String, event: PTEvent,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.deleteEvent(event)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    success("Event deleted successfully.")
                case 401:
                    failure("Invalid token.")
                case 404:
                    failure("Event by that id does not exist.")
                default:
                    failure("There is a problem connecting to the server.")
                }
            }
        }
    }
    
    public func listEvents(apiToken: String, success: @escaping (_ events: [String : PTDay])->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.listEvents).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let events = response.value?.events {
                        success(events)
                    } else {
                        failure("There is a problem getting the events.")
                    }
                case 401:
                        failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("User doesn't have events.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Periods Request
    public func createPeriod(period: PTPeriod, success: @escaping (_ periodId: Int)->(), failure: @escaping (_ msg: String?)->()) {
      sessionManager.request(PTRouter.createPeriod(period)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let periodId = response.value?.id {
                        success(periodId)
                    } else {
                        failure("There is a problem creating the event")
                    }
                case 401:
                    failure("Invalid token.")
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editPeriod(period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.editPeriod(period)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "Period edited properly"
                        success(response)
                    } else {
                        failure("There's an error edditing the period")
                    }
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deletePeriod(period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.deletePeriod(period)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        success(response)
                    } else {
                        failure("There's an error deleting the period")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Period by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Blocks Request
    public func createBlock(block: PTBlock, success: @escaping (_ blockId: Int)->(), failure: @escaping (_ msg: String?)->()) {
       sessionManager.request(PTRouter.createBlock(block)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let blockId = response.value?.id {
                        success(blockId)
                    } else {
                        failure("There's an error creating the block")
                    }
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors")
                    }
                case 401:
                    failure("Invalid token.")
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editBlock(block: PTBlock,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.editBlock(block)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        success(response)
                    } else {
                        failure("There's a problem edditing the block")
                    }
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Validator errors")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Period by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteBlock(block: PTBlock, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.deleteBlock(block)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        success(response)
                    } else {
                        failure("There's a problem deleting the block")
                    }
                case 401:
                    failure("Invalid token.")
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Block by that id doesn't exist.")
                    }
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Period not found")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Sessions Request
    public func createSession(session: PTSession,success: @escaping (_ sessionId: Int)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.createSession(session)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let sessionId = response.value?.id {
                        success(sessionId)
                    } else {
                        failure("There's a problem creating the session")
                    }
                case 400:
                    failure("Validator errors.")
                case 401:
                    failure("Invalid token.")
                case 412:
                    failure("Empty Data")
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteSession(session: PTSession,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.deleteSession(session)).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        //"Session deleted successfully."
                        success(response)
                    } else {
                        failure("There's an error deleting the delete")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Session by that id doesn't exist.")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func listSessions(success: @escaping (_ sessions: [PTSession]?)->(), failure: @escaping (_ msg: String?)->()) {
        sessionManager.request(PTRouter.listSessions).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let sessions = response.value?.sessions {
                        success(sessions)
                    } else {
                        failure("There's a problem getting sessions")
                    }
                case 400:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("Student doesn't have sessions.")
                    }
                case 401:
                    failure("Invalid token.")
                case 404:
                    if let error = response.value?.response {
                        failure(error)
                    } else {
                        failure("User not found")
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
}

