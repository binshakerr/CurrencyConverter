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
    var converterUnitSubject: BehaviorRelay<ConvertUnit> { get }
    func viewDidLoad()
}

protocol ConverterViewModelOutputs: AnyObject {
    var currencySubject: BehaviorRelay<[CurrencySymbol]> { get }
    var conversionSubject: BehaviorRelay<Double> { get }
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
    var converterUnitSubject = BehaviorRelay<ConvertUnit>(value: ConvertUnit(from: "", to: "", amount: 1.0))

    
    //MARK: - Outputs
    let screenTitle = "Currency Converter"
    let currencySubject = BehaviorRelay<[CurrencySymbol]>(value: [])
    let conversionSubject = BehaviorRelay<Double>(value: 0)
    let stateSubject = BehaviorRelay<DataState?>(value: nil)
    let errorSubject = BehaviorRelay<String?>(value: nil)
    
    //MARK: -
    private let repository: ConverterRepositoryType
    private let disposeBag = DisposeBag()
    
    init(repository: ConverterRepositoryType) {
        self.repository = repository
        bindInputs()
    }
    
    var isValid: Observable<Bool> {
        converterUnitSubject.map {
            guard $0.amount > 0 else { return false }
            guard !$0.from.prefix(3).isEmpty else { return false }
            guard !$0.to.prefix(3).isEmpty else { return false }
            return true
        }
    }
    
    private func bindInputs() {
        isValid
            .subscribe(onNext: { [weak self] inputsValid in
                guard let self = self else { return }
                if inputsValid {
                    self.convertCurrency(from: self.converterUnitSubject.value.from, to: self.converterUnitSubject.value.to, amount: self.converterUnitSubject.value.amount)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        getCurrencies()
    }
    
    private func getCurrencies() {
        stateSubject.accept(.loading)
        
        repository
            .getCurrencies()
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.stateSubject.accept(response.count > 0 ? .populated : .empty)
                self.currencySubject.accept(response.sorted(by: { $0.symbol < $1.symbol } ))
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
  
    
    private func convertCurrency(from: String, to: String, amount: Float) {
        stateSubject.accept(.loading)
        
        repository
            .convertCurrency(from: from, to: to, amount: amount)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.stateSubject.accept(.populated)
                self.conversionSubject.accept(response.result)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}
