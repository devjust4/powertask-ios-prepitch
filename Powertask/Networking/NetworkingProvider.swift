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
    let statusOk = 200...299
    let tempToken: String = "ya29.A0ARrdaM8q778vnOf4vnvbCNzmZ_HC8yXyhzf3pTzxCOAPcAw29wyulU8lJlLnxm4qBwrkuSlH4IF7mRssr7BanvTEATUeRQoNyZkJdSG55MfLXEMLmGcajPC79-aut_5sQ0A9NqeWjUCFj5aLN3TIqREbxgOnng"
    let tempApiToken: String = "$2y$10$gyMzuSL41tG/9u/ToCRWWepV4AYsB5VmpoWiwi5iRXvslNzf4kN9e"
    
    //    func login(email: String, password: String, success: @escaping () -> (), failure: @escaping (_ error: String) ->()) {
    //        let kBaseUrl = "\(kBaseUrl)/login"
    //        let parameters: Parameters = [
    //            "email" : email,
    //            "password" : password
    //        ]
    //        AF.request(kBaseUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseDecodable (of: ) { response in
    //            if let httpCode = response.response?.statusCode {
    //                switch httpCode {
    //                case 200:
    //                    if let user = response.value?.user {
    //                        success(user)
    //                    }
    //                case 400...499:
    //                    failure(response.value?.msg ?? "Error")
    //                default:
    //                    failure("There is a problem connecting to the server")
    //                }
    //            }
    //        }
    //    }
    
    // MARK: - Task Requests
    public func listTasks(token: String, success: @escaping (_ tasks: [SPTTask])->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken,
            "token" : tempToken
        ]
        AF.request("\(kBaseUrl)task/list", method: .get, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let tasks = response.value?.tasks {
                success(tasks)
            } else {
                failure(response.error.debugDescription)
            }
        }
    }
    
    public func createTask(task: PTTask, token: String, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
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
            if response.response?.statusCode == 201 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    public func editTask(task: PTTask, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        let parameters: Parameters = [
            "name": task.name,
            "date_completed": task.startDate?.formatToString(using: .serverDate),
            "description": task.description,
            "subject_id": task.subject?.id
        ]
        
        AF.request("\(kBaseUrl)task/edit/\(task.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    public func deleteTask(taskId: Int, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        AF.request("\(kBaseUrl)task/delete/\(taskId)", method: .delete, encoding: JSONEncoding.default).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    public func toggleTask(taskID: Int, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        AF.request("\(kBaseUrl)task/toggle/\(taskID)", method: .put, encoding: JSONEncoding.default).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    // MARK: - Subtask Requests
    
    //    public func createSubtask(subtask: PTSubtask, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
    //        let parameters: Parameters = ["name": subtask.name!]
    //
    //            AF.request("\(kBaseUrl)subtask/create", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200...600).responseDecodable(of: SPTResponse.self) { response in
    //                if response.response?.statusCode == 201 {
    //                    success(response.value?.response)
    //                } else {
    //                    failure(response.value?.response)
    //                }
    //            }
    //        }
    //    public func editSubtask(subtask: PTSubtask, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
    //            let parameters: Parameters = [
    //                "name": subtask.name,
    //                "description": subtask.description
    //            ]
    //
    //        AF.request("\(kBaseUrl)subtask/edit/\(subtask.)", method: .put, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200...600).responseDecodable(of: SPTResponse.self) { response in
    //                if response.response?.statusCode == 200 {
    //                    success(response.value?.response)
    //                } else {
    //                    failure(response.value?.response)
    //                }
    //            }
    //        }
    //        public func deleteSubtask(success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->(), subtaskID: Int) {
    //            AF.request("\(kBaseUrl)subtask/delete/\(subtaskID)", method: .delete, encoding: JSONEncoding.default).validate(statusCode: 200...600).responseDecodable(of: SPTResponse.self) { response in
    //                if response.response?.statusCode == 200 {
    //                    success(response.value?.response)
    //                } else {
    //                    failure(response.value?.response)
    //                }
    //            }
    //        }
    //        public func toggleSubtask(success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->(), subtaskID: Int) {
    //            AF.request("\(kBaseUrl)subtask/toggle/\(subtaskID)", method: .put, encoding: JSONEncoding.default).validate(statusCode: 200...600).responseDecodable(of: SPTResponse.self) { response in
    //                if response.response?.statusCode == 200 {
    //                    success(response.value?.response)
    //                } else {
    //                    failure(response.value?.response)
    //                }
    //            }
    //        }
    
    // MARK: - Event Request
    
    public func createEvent(event: PTEvent, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        let parameters: Parameters = ["name": event.name,
                                      "type": event.type,
                                      "date_start": event.startDate.formatToString(using: .serverDate),
                                      "date_end": event.endDate?.formatToString(using: .serverDate),
                                      "subject_id": event.subject?.id
        ]
        
        AF.request("\(kBaseUrl)event/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 201 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func editEvent(event: PTEvent, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        let parameters: Parameters = [
            "name": event.name,
            "type": event.type,
            "date_start": event.startDate.formatToString(using: .serverDate),
            "date_end": event.endDate?.formatToString(using: .serverDate),
            "subject_id": event.subject?.id
        ]
        
        AF.request("\(kBaseUrl)event/edit/\(event.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func deleteEvent(event: PTEvent,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        AF.request("\(kBaseUrl)event/delete/\(event.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    public func listEvents(success: @escaping (_ events: [String : PTDay])->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        AF.request("\(kBaseUrl)event/list/", method: .get).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            
            if let events = response.value?.events {
                success(events)
            } else {
                failure(response.error?.errorDescription)
            }
        }
    }
    
    // MARK: - Courses Request
    public func createCourse(course: PTCourse, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        let parameters: Parameters = ["name": course.name]
        
        AF.request("\(kBaseUrl)course/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 201 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func editCourse(course: PTCourse,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        let parameters: Parameters = [
            "name": course.name
        ]
        
        AF.request("\(kBaseUrl)course/edit/\(course.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func deleteCourse(course: PTCourse,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        AF.request("\(kBaseUrl)course/delete/\(course.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func listCourse(success: @escaping (_ courses: [PTCourse]?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        AF.request("\(kBaseUrl)course/list", method: .get, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if ((response.value?.courses!.isEmpty) != nil) {
                success(response.value?.courses)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    // MARK: - Periods Request
    public func createPeriod(period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        let parameters: Parameters = ["name": period.name,
                                      "date_start": period.startDate?.formatToString(using: .serverDate),
                                      "date_end": period.endDate?.formatToString(using: .serverDate)]
        
        AF.request("\(kBaseUrl)period/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 201 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func editPeriod(period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        let parameters: Parameters = [
            "name": period.name,
            "date_start": period.startDate?.formatToString(using: .serverDate),
            "date_end": period.endDate?.formatToString(using: .serverDate)
        ]
        
        AF.request("\(kBaseUrl)period/edit", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func deletePeriod(period: PTPeriod,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        AF.request("\(kBaseUrl)period/delete/\(period.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    // MARK: - Blocks Request
    public func createBlock(block: PTBlock, success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        let parameters: Parameters = ["time_start": block.timeStart?.formatToString(using: .serverDate),
                                      "time_end": block.timeEnd?.formatToString(using: .serverDate),
                                      "day": String(block.day!),
                                      "subject_id": block.subject?.id]
        
        AF.request("\(kBaseUrl)block/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 201 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func editBlock(block: PTBlock,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        let parameters: Parameters = [
            "time_start": block.timeStart?.formatToString(using: .serverDate),
            "time_end": block.timeEnd?.formatToString(using: .serverDate),
            "day": String(block.day!),
            "subject_id": block.subject?.id
        ]
        
        AF.request("\(kBaseUrl)block/edit/\(block.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func deleteBlock(block: PTBlock,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        AF.request("\(kBaseUrl)block/delete/\(block.id)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 200 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    
    // MARK: - Sessions Request
    public func createSession(session: PTSession,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        
        // TODO: - Revisar
        let parameters: Parameters = ["quantity": session.quantity,
                                      "duration": session.duration,
                                      "total_time": session.duration,
                                      "task_id": session.task?.id,
        ]
        
        AF.request("\(kBaseUrl)session/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if response.response?.statusCode == 201 {
                success(response.value?.response)
            } else {
                failure(response.value?.response)
            }
        }
    }
    public func deleteSession(session: PTSession,success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        guard let sessionId = session.id else { failure("La sesión no tiene id") }
        
        AF.request("\(kBaseUrl)session/delete/\(sessionId)", method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let response = response.value?.response {
                success(response)
            } else if let error = response.error?.errorDescription {
                failure(error)
            }
        }
    }
    
    public func listSessions(success: @escaping (_ sessions: [PTSession]?)->(), failure: @escaping (_ msg: String?)->()) {
        let headers: HTTPHeaders = [
            "api-token" : tempApiToken
        ]
        AF.request("\(kBaseUrl)course/list", method: .get, headers: headers).validate(statusCode: statusOk).responseDecodable(of: SPTResponse.self) { response in
            if let sessions = response.value?.sessions {
                success(sessions)
            } else if let error = response.error?.errorDescription{
                failure(error)
            }
        }
    }
    
    
}

