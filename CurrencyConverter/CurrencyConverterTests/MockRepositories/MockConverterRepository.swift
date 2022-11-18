//
//  MockConverterRepository.swift
//  CurrencyConverterTests
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation
import RxSwift
@testable import CurrencyConverter


class MockConverterRepository: ConverterRepositoryType {
    
    var currenciesStubData: [CurrencySymbol]?
    var convertStubData: ConvertResult?
    var historyStubData: HistoryResponse?
    
    func getCurrencies() -> Observable<[CurrencySymbol]> {
        if let response = currenciesStubData {
            return .just(response)
        }
        
        return .error(MockError.noDataFound)
    }
    
    func convertCurrency(from: String, to: String, amount: Float) -> Observable<ConvertResult> {
        if let response = convertStubData {
            return .just(response)
        }
        
        return .error(MockError.noDataFound)
    }
    
    func getHistory(startDate: String, endDate: String, base: String, symbols: String) -> Observable<HistoryResponse> {
        if let response = historyStubData {
            return .just(response)
        }
        
        return .error(MockError.noDataFound)
    }
    
}
