//
//  Parser.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation
import Alamofire

protocol ParserType {
    func parseResponse<T: Decodable>(_ result: AFDataResponse<Any>, type: T.Type, completion: @escaping(Result<T, Error>) -> Void)
}


class Parser {
    
    private let decoder = JSONDecoder()
}


extension Parser: ParserType {
    
    func parseResponse<T>(_ result: AFDataResponse<Any>, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let statusCode = result.response?.statusCode ?? 0
        
        switch result.result {
        case .success:
            guard let data = result.data else { return }
            do {
                let result = try decoder.decode(type.self, from: data)
                completion(.success(result))
            } catch let error {
                // custom error
                do {
                    let result = try decoder.decode(DetailedErrorResponse.self, from: data)
                    let userInfo: [String : Any] = [
                        NSLocalizedDescriptionKey:  NSLocalizedString("Error code: \(statusCode)", value: result.error.info, comment: "") ,
                    ]
                    let error = NSError(domain: "", code: 0, userInfo: userInfo)
                    completion(.failure(error))
                } catch let error {
                    completion(.failure(error))
                }
                
                completion(.failure(error))
            }
        case .failure(let error):
            guard let data = result.data else {
                completion(.failure(error))
                return
            }
            do {
                let result = try decoder.decode(ErrorResponse.self, from: data)
                let userInfo: [String : Any] = [
                    NSLocalizedDescriptionKey:  NSLocalizedString("Error code: \(statusCode)", value: result.message, comment: "") ,
                ]
                let error = NSError(domain: "", code: 0, userInfo: userInfo)
                completion(.failure(error))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
