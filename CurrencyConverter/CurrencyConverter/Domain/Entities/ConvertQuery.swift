//
//  ConvertQuery.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation

struct ConvertQuery: Decodable {
    let amount: Float
    let from: String
    let to: String
}
