//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import Foundation
import Alamofire

var customSessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true
    
    let networkLogger = NetworkLogger()
    return Session(
        configuration: configuration,
        eventMonitors: [networkLogger])
}()

protocol NetworkManagerType {
    func request<T: Decodable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>) -> Void)
}

class NetworkManager {
    
    private let session: Session
    static let shared = NetworkManager(session: customSessionManager)
    private let parser = Parser()
    
    init(session: Session) {
        self.session = session
    }
}

extension NetworkManager: NetworkManagerType {
    
    func request<T: Decodable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        
        // Check Internet Connection
        if NetworkReachability.shared.status == .notReachable {
            let userInfo: [String : Any] = [
                NSLocalizedDescriptionKey:  NSLocalizedString("Connection", value: "Please check your internet connectivity", comment: "") ,
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Connection", value: "No Internet Connection", comment: "")
            ]
            let error = NSError(domain: "", code: 0, userInfo: userInfo)
            completion(.failure(error))
        }
        
        // Make Request
        session
            .request(request)
            .validate()
            .responseJSON { [weak self] result in
                self?.parser.parseResponse(result, type: type) { result in
                    completion(result)
                }
            }
    }
}
