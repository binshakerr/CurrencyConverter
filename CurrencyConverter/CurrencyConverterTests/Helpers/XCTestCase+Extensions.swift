//
//  XCTestCase+Extensions.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import XCTest
import Alamofire

extension XCTestCase {
    func getMockSessionFor(_ data: Data) -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        MockURLProtocol.stubResponseData = data
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        return Session(configuration: configuration)
    }
}
