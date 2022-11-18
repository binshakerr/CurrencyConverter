//
//  ConvertResult.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation

struct ConvertResult: Decodable {
    let date: String
    let historical: String?
    let info: ConvertInfo
    let query: ConvertQuery
    let result: Double
    let success: Bool
}
