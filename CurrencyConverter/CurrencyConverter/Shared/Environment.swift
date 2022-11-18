//
//  Environment.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import Foundation

public enum Environment {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let apiKey = "API_KEY"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let value = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return value
    }()
    
    // MARK: - Plist values
    static let baseURL: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return value
    }()
    
    static let apiKey: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.apiKey] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return value
    }()
    
}
