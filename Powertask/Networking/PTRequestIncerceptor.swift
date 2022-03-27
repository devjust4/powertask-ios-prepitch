//
//  PTRequestIncerceptor.swift
//  Powertask
//
//  Created by Daniel Torres on 28/2/22.
//
import Foundation
import Alamofire
import GoogleSignIn

class PTRequestInterceptor: RequestInterceptor {
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        if let apiToken = PTUser.shared.apiToken {
            urlRequest.setValue("$2y$10$78jyP4gn0/W/Amm.NtAOKu9VmaXqsTS/ywwI/gEeRWRX6yU/A52ie", forHTTPHeaderField: "api-token")
        }
        urlRequest.setValue("$2y$10$78jyP4gn0/W/Amm.NtAOKu9VmaXqsTS/ywwI/gEeRWRX6yU/A52ie", forHTTPHeaderField: "api-token")

        
        if let googleToken = GIDSignIn.sharedInstance.currentUser?.authentication.accessToken {
            urlRequest.setValue("ya29.A0ARrdaM9agAGhyqv4yMf0_ak6dVdHL7khADktvSOnD9FB2oCRqDwPo89wBVfd0-UhnkrQMVaebiviQNEU95-Zv-Il5YxJiLjNuHfPxiL6zKsTqKfwCVUdkRSBeGXNQEpdmP0n6r-0mX5M9VkQz2dxaTeqH76nQFtarcRPkDmiZ_YcteIqPek", forHTTPHeaderField: "token")
        }
        urlRequest.setValue("ya29.A0ARrdaM9agAGhyqv4yMf0_ak6dVdHL7khADktvSOnD9FB2oCRqDwPo89wBVfd0-UhnkrQMVaebiviQNEU95-Zv-Il5YxJiLjNuHfPxiL6zKsTqKfwCVUdkRSBeGXNQEpdmP0n6r-0mX5M9VkQz2dxaTeqH76nQFtarcRPkDmiZ_YcteIqPek", forHTTPHeaderField: "token")
        
        
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        let response = request.task?.response as? HTTPURLResponse
        //Retry for 5xx status codes
        if let statusCode = response?.statusCode,
           (500...599).contains(statusCode),
           request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
