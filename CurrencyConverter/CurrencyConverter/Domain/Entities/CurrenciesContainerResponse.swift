//
//  CurrenciesContainerResponse.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation

struct CurrenciesContainerResponse: Decodable {
    let success: Bool
    let symbols: [String: String]
}
