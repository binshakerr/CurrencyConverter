//
//  Utils.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import Foundation

class Utils {
    
    enum MockResponseType: String {
        case CurrenciesSuccessResponse = "CurrenciesSuccessResponse"
        case ConvertSuccessResponse = "ConvertSuccessResponse"
        case ConvertWrongAmountResponse = "ConvertWrongAmountResponse"
        case HistorySuccessResponse = "HistorySuccessResponse"
        case HistoryWrongDateResponse = "HistoryWrongDateResponse"
        
        var sampleData: Data? {
            return jsonDataFromFile(self.rawValue)
        }
        
        func sampleDataFor(_ testClass: AnyObject) -> Data? {
            let bundle = Bundle(for: type(of: testClass))
            return jsonDataFromFile(self.rawValue, bundle: bundle)
        }
        
        func jsonDataFromFile(_ fileName: String, bundle: Bundle = Bundle.main) -> Data? {
            guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
                print("Error: invalid file URL")
                return nil
            }
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch let error {
                print("Error: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
