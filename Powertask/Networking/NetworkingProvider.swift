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
    
//    func login(email: String, password: String, success: @escaping () -> (), failure: @escaping (_ error: String) ->()) {
//        let url = "\(kBaseUrl)/login"
//        let parameters: Parameters = [
//            "email" : email,
//            "password" : password
//        ]
//        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseDecodable (of: ) { response in
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
    public func createTask(success: @escaping (_ msg: String?)->(), failure: @escaping (_ msg: String?)->(), task: PTTask, api: String) {
        let headers: HTTPHeaders = [
            "token" : api
        ]
        let parameters: Parameters = ["name": task.name,
                                      "date_start": task.serverHandoverDate,
                                      "description": task.description,
                                      "student_id": task.studentId!]
        if let _ = task.subject {
            let parameters: Parameters = ["name": task.name,
                                          "date_start": task.startDate,
                                          "description": task.description,
                                          "student_id": task.studentId!,
                                          "subject_id" : task.subject!.id]
        }
            
            AF.request("\(kBaseUrl)task/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200...600).responseDecodable(of: Response.self) { response in
                if response.response?.statusCode == 201 {
                    success(response.value?.response)
                } else {
                    failure(response.value?.response)
                }
            }
        }

}

