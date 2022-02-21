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
    
    // MARK: - Register Request
    func registerOrLogin(googleToken: String, success: @escaping (_ token: String) -> (), failure: @escaping (_ error: String) ->()) {
        let kBaseUrl = "\(kBaseUrl)loginRegister"
        let headers: HTTPHeaders = [
            "token" : googleToken
        ]
        
        AF.request(kBaseUrl, method: .put, encoding: JSONEncoding.default, headers: headers).responseDecodable (of: SPTResponse.self) { response in
            if let token = response.value?.token {
                success(token)
            } else {
                failure("No token")
            }
        }
    }
    
    //MARK: - Subjects Request
    func getSubjects(googleToken: String, apiToken: String, success: @escaping (_ subjects: [PTSubject]) -> (), failure: @escaping (_ error: String) ->()) {
        let kBaseUrl = "\(kBaseUrl)subject/list"
        let headers: HTTPHeaders = [
            "api-token" : apiToken,
            "token" : googleToken
        ]
        
        AF.request(kBaseUrl, method: .put, encoding: JSONEncoding.default, headers: headers).responseDecodable (of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let subjects = response.value?.subjects {
                        success(subjects)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Student not found"
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editTask(apiToken: String, subject: PTSubject, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = [
            "name": subject.name,
            "color": subject.color
        ]
        
        AF.request("\(kBaseUrl)task/edit/\(subject.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        //   "Subject edited properly"
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // 400: "Validator errors";
                        failure(error)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Subject by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Task Requests
    public func listTasks(apiToken: String, googleToken: String, success: @escaping (_ tasks: [PTTask])->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken,
            "token" : googleToken
        ]
        AF.request("\(kBaseUrl)task/list", method: .get, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            print(response.error)
            if let httpCode = response.response?.statusCode {
                print(httpCode)
                switch httpCode {
                case 200:
                    if let tasks = response.value?.tasks {
                        success(tasks)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Student doesn't have tasks"
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func createTask(apiToken: String, task: PTTask, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = ["name": task.name,
                                      "date_handover": task.startDate?.formatToString(using: .serverDate),
                                      "description": task.description,
                                      "student_id": task.studentId!]
        if let _ = task.subject {
            let parameters: Parameters = ["name": task.name,
                                          "date_handover": task.startDate?.formatToString(using: .serverDate),
                                          "description": task.description,
                                          "student_id": task.studentId,
                                          "subject_id" : task.subject!.id]
        }
        
        AF.request("\(kBaseUrl)task/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            print(response.debugDescription)
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let response = response.value?.response {
                        // "Task created properly with id
                        // TODO: Debe devolver ID
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // "Validator errors";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editTask(apiToken: String, task: PTTask, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = [
            "name": task.name,
            "date_completed": task.startDate?.formatToString(using: .serverDate),
            "description": task.description,
            "subject_id": task.subject?.id
        ]
        
        AF.request("\(kBaseUrl)task/edit/\(task.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        //  "Task edited properly"
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // 400: "Validator errors";
                        failure(error)
                    }
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
    
    public func deleteTask(apiToken: String, taskId: Int, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        AF.request("\(kBaseUrl)task/delete/\(taskId)", method: .delete, encoding: JSONEncoding.default).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // ""Task deleted successfully."
                        success(response)
                    }
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
    
    public func toggleTask(apiToken: String, taskID: Int, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        AF.request("\(kBaseUrl)task/toggle/\(taskID)", method: .put, encoding: JSONEncoding.default).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "boolean"
                        success(response)
                    }
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
    
    // MARK: - Subtask Requests
    public func toggleSubtask(apiToken: String, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->(), subtaskID: Int) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        AF.request("\(kBaseUrl)subtask/toggle/\(subtaskID)", method: .put, encoding: JSONEncoding.default).validate(statusCode: 200...600).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "boolean"
                        success(response)
                    }
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
    public func createEvent(apiToken: String, event: PTEvent, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        let parameters: Parameters = ["name": event.name,
                                      "type": event.type,
                                      "date_start": event.startDate.formatToString(using: .serverDate),
                                      "date_end": event.endDate?.formatToString(using: .serverDate),
                                      "subject_id": event.subject?.id
        ]
        
        AF.request("\(kBaseUrl)event/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let response = response.value?.response {
                        // "Event created properly with id "
                        // TODO: Debe devolver ID
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // "Validator errors";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editEvent(apiToken: String, event: PTEvent, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        let parameters: Parameters = [
            "name": event.name,
            "type": event.type,
            "date_start": event.startDate.formatToString(using: .serverDate),
            "date_end": event.endDate?.formatToString(using: .serverDate),
            "subject_id": event.subject?.id
        ]
        
        AF.request("\(kBaseUrl)event/edit/\(event.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "Event edited properly"
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // Validator errors
                        failure(error)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Event by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteEvent(apiToken: String, event: PTEvent,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        AF.request("\(kBaseUrl)event/delete/\(event.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "Event deleted successfully."
                        success(response)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Event by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func listEvents(apiToken: String, success: @escaping (_ events: [String : PTDay])->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        AF.request("\(kBaseUrl)event/list/", method: .get).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let events = response.value?.events {
                        success(events)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "User doesn't have events"
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Courses Request
    public func createCourse(apiToken: String, course: PTCourse, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = ["name": course.name]
        
        AF.request("\(kBaseUrl)course/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let response = response.value?.response {
                        // "Course created properly with id "
                        // TODO: Debe devolver ID
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // "Validator errors";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editCourse(apiToken: String, course: PTCourse,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = [
            "name": course.name
        ]
        
        AF.request("\(kBaseUrl)course/edit/\(course.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "Course edited properly"
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // Validator errors
                        failure(error)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Course by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteCourse(apiToken: String, course: PTCourse,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        AF.request("\(kBaseUrl)course/delete/\(course.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "Course deleted successfully."
                        success(response)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Course by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func listCourse(apiToken: String, success: @escaping (_ courses: [PTCourse]?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        AF.request("\(kBaseUrl)course/list", method: .get, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let courses = response.value?.courses {
                        success(courses)
                    }
                case 400:
                    if let error = response.value?.response {
                        // "Student doesn't have courses"
                        failure(error)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "User not found."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Periods Request
    public func createPeriod(apiToken: String, period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = ["name": period.name,
                                      "date_start": period.startDate?.formatToString(using: .serverDate),
                                      "date_end": period.endDate?.formatToString(using: .serverDate)]
        
        AF.request("\(kBaseUrl)period/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let response = response.value?.response {
                        // "Period created properly with id "
                        // TODO: Debe devolver ID
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // "Validator errors";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editPeriod(apiToken: String, period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = [
            "name": period.name,
            "date_start": period.startDate?.formatToString(using: .serverDate),
            "date_end": period.endDate?.formatToString(using: .serverDate)
        ]
        
        AF.request("\(kBaseUrl)period/edit", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "Period edited properly"
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // "Validator errors";
                        failure(error)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Period by that id doesn't exist.";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deletePeriod(apiToken: String, period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        AF.request("\(kBaseUrl)period/delete/\(period.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        //   "Period deleted successfully."
                        success(response)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Period by that id doesn't exist.";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Blocks Request
    public func createBlock(apiToken: String, block: PTBlock, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = ["time_start": block.timeStart?.formatToString(using: .serverDate),
                                      "time_end": block.timeEnd?.formatToString(using: .serverDate),
                                      "day": String(block.day!),
                                      "subject_id": block.subject?.id]
        
        AF.request("\(kBaseUrl)block/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let response = response.value?.response {
                        //  Block created properly with id
                        // TODO: Debe devolver el id
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // 400: "Validator errors";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func editBlock(apiToken: String, block: PTBlock,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        let parameters: Parameters = [
            "time_start": block.timeStart?.formatToString(using: .serverDate),
            "time_end": block.timeEnd?.formatToString(using: .serverDate),
            "day": String(block.day!),
            "subject_id": block.subject?.id
        ]
        
        AF.request("\(kBaseUrl)block/edit/\(block.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        //  "Block edited properly"
                        success(response)
                    }
                case 400:
                    if let error = response.value?.response {
                        // 400: "Validator errors";
                        failure(error)
                    }
                case 404:
                    if let error = response.value?.response {
                        // 404: "Period by that id doesn't exist.";
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteBlock(apiToken: String, block: PTBlock,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        AF.request("\(kBaseUrl)block/delete/\(block.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        // "Block deleted successfully."
                        success(response)
                    }
                case 400...499:
                    if let error = response.value?.response {
                        // 404: "Block by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    // MARK: - Sessions Request
    public func createSession(apiToken: String, session: PTSession,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        // TODO: - Revisar
        let parameters: Parameters = ["quantity": session.quantity,
                                      "duration": session.duration,
                                      "total_time": session.duration,
                                      "task_id": session.task?.id,
        ]
        
        AF.request("\(kBaseUrl)session/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 201:
                    if let response = response.value?.response {
                        // "Session created properly with id "
                        // TODO: Debe devolver ID
                        success(response)
                    }
                case 400...499:
                    if let error = response.value?.response {
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func deleteSession(apiToken: String, session: PTSession,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        
        guard let sessionId = session.id else { return }
        
        AF.request("\(kBaseUrl)session/delete/\(sessionId)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let response = response.value?.response {
                        //"Session deleted successfully."
                        success(response)
                    }
                case 404:
                    if let error = response.value?.response {
                        // "Session by that id doesn't exist."
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
    
    public func listSessions(apiToken: String, success: @escaping (_ sessions: [PTSession]?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : apiToken
        ]
        AF.request("\(kBaseUrl)course/list", method: .get, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let httpCode = response.response?.statusCode {
                switch httpCode {
                case 200:
                    if let sessions = response.value?.sessions {
                        success(sessions)
                    }
                case 400:
                    if let error = response.value?.response {
                        //"Student doesn't have sessions."
                        failure(error)
                    }
                case 404:
                    if let error = response.value?.response {
                        //"User not found"
                        failure(error)
                    }
                default:
                    failure("There is a problem connecting to the server")
                }
            }
        }
    }
}

