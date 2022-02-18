//
//  NetworkingProvider.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import Foundation
static let shared = NetworkingProvider()
private let kBaseUrl = "http://powertask.kurokiji.com/public/api/"
let statusOk = 200...499

func login(email: String, password: String, success: @escaping (_ user: User) -> (), failure: @escaping (_ error: String) ->()) {
    let url = "\(kBaseUrl)/login"
    let parameters: Parameters = [
        "email" : email,
        "password" : password
    ]
    AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseDecodable (of: Login.self) { response in
        if let httpCode = response.response?.statusCode {
            switch httpCode {
            case 200:
                if let user = response.value?.user {
                    success(user)
                }
            case 400...499:
                failure(response.value?.msg ?? "Error")
            default:
                failure("There is a problem connecting to the server")
            }
        }
    }
}
