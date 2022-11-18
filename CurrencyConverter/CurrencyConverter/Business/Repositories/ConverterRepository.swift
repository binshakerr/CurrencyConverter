//
//  ConverterRepository.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation
import RxSwift

protocol ConverterRepositoryType {
    func getCurrencies() -> Observable<[CurrencySymbol]>
    func convertCurrency(from: String, to: String, amount: Float) -> Observable<ConvertResult>
}


class ConverterRepository {
    
    private let networkManager: NetworkManagerType
 
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
}


extension ConverterRepository: ConverterRepositoryType {
    
    func getCurrencies() -> Observable<[CurrencySymbol]> {
        return Observable.create { [weak self] observer in
            let request = ConverterService.symbols
            self?.networkManager.request(request, type: CurrenciesContainerResponse.self) { result in
                switch result {
                case .success(let response):
                    let symbols = response.symbols.map {
                        CurrencySymbol(symbol: $0.key, fullName: $0.value)
                    }
                    observer.onNext(symbols)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func convertCurrency(from: String, to: String, amount: Float) -> Observable<ConvertResult> {
        return Observable.create { [weak self] observer in
            let request = ConverterService.convert(amount: amount, from: from, to: to)
            self?.networkManager.request(request, type: ConvertResult.self) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
