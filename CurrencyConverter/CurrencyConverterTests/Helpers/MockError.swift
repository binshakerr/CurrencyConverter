//
//  MockError.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation

enum MockError: Error, LocalizedError {
    case noDataFound
 
    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return "No data found"
        }
    }
}
