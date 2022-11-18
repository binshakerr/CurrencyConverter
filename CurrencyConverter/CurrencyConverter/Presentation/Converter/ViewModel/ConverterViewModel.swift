//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol ConverterViewModelInputs: AnyObject {
    var searchSubject: PublishSubject<String> { get }
    func getCurrencies()
}

protocol ConverterViewModelOutputs: AnyObject {
    var dataSubject: BehaviorRelay<[CurrencySymbol]> { get }
    var stateSubject: BehaviorRelay<DataState?> { get }
    var errorSubject: BehaviorRelay<String?> { get }
    var screenTitle: String { get }
}


protocol ConverterViewModelProtocol: ConverterViewModelInputs, ConverterViewModelOutputs {
    var inputs: ConverterViewModelInputs { get }
    var outputs: ConverterViewModelOutputs { get }
}


final class ConverterViewModel: ConverterViewModelProtocol {
    
    var inputs: ConverterViewModelInputs { self }
    var outputs: ConverterViewModelOutputs { self }
    
    //MARK: - Inputs
    let searchSubject = PublishSubject<String>()


    //MARK: - Outputs
    let screenTitle = "Currency Converter"
    let dataSubject = BehaviorRelay<[CurrencySymbol]>(value: [])
    let stateSubject = BehaviorRelay<DataState?>(value: nil)
    let errorSubject = BehaviorRelay<String?>(value: nil)
    
    //MARK: -
    private let repository: ConverterRepositoryType
    private let disposeBag = DisposeBag()
    
    init(repository: ConverterRepositoryType) {
        self.repository = repository
    }
    
    func getCurrencies() {
        stateSubject.accept(.loading)
        
        repository
            .getCurrencies()
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.stateSubject.accept(response.count > 0 ? .populated : .empty)
                self.dataSubject.accept(response)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    
}
