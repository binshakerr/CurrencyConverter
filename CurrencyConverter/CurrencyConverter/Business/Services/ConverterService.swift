//
//  ConverterService.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation
import Alamofire

enum ConverterService {
    case symbols
    case convert(amount: Float, from: String, to: String)
    case timeseries(start_date: String, end_date: String, base: String, symbols: String)
}

extension ConverterService: EndPoint {
    
    var method: HTTPMethod {
        switch self {
        case .symbols:
            return .get
        case .convert:
            return .get
        case .timeseries:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .symbols:
            return "/symbols"
        case .convert:
            return "/convert"
        case .timeseries:
            return "/timeseries"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        
        case let .convert(amount, from, to):
            let parameters: [String: Any] =
            ["amount": amount,
             "from": from,
             "to": to]
            return parameters
            
        case let .timeseries(start_date, end_date, base, symbols):
            let parameters: [String: Any] =
            ["start_date": start_date,
             "end_date": end_date,
             "base": base,
             "symbols": symbols]
            return parameters
            
        case .symbols:
            return nil
        }
        
    }
    
    var headers: [String: String] {
        return makeDefaultHeaders()
    }
    
}


extension ConverterService: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return try makeURLRequest()
    }
}
