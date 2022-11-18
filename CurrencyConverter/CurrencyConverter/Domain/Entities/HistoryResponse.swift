//
//  HistoryResponse.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation

struct HistoryResponse: Decodable {
    let base: String
    let end_date: String
    let start_date: String
    let success: Bool
    let rates: [String: [String: Double]]
}
