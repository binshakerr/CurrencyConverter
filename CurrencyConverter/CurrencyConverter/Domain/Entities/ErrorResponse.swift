//
//  ErrorResponse.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import Foundation

struct ErrorResponse: Decodable {
    var message: String
}

struct DetailedErrorResponse: Decodable {
    let error: DetailedError
}

struct DetailedError: Decodable {
    let code: Int
    let info: String
    let type: String
}
