//
//  HistoryViewModel.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol HistoryViewModelInputs: AnyObject {
    func viewDidLoad()
    var daysRange: [String] { get set }
}

protocol HistoryViewModelOutputs: AnyObject {
    var historySubject: BehaviorRelay<[HistoryRate]> { get }
    var stateSubject: BehaviorRelay<DataState?> { get }
    var errorSubject: BehaviorRelay<String?> { get }
    var screenTitle: String { get }
    var cellId: String { get }
    var messageLabelTitle: String { get }
}

protocol HistoryViewModelProtocol: HistoryViewModelInputs, HistoryViewModelOutputs {
    var inputs: HistoryViewModelInputs { get }
    var outputs: HistoryViewModelOutputs { get }
}

final class HistoryViewModel: HistoryViewModelProtocol {
    
    var inputs: HistoryViewModelInputs { self }
    var outputs: HistoryViewModelOutputs { self }
    
    private let repository: ConverterRepositoryType
    private let convertUnit: ConvertUnit
    private let disposeBag = DisposeBag()
    
    let historySubject = BehaviorRelay<[HistoryRate]>(value: [])
    let stateSubject = BehaviorRelay<DataState?>(value: nil)
    let errorSubject = BehaviorRelay<String?>(value: nil)
    var screenTitle = "History"
    let cellId = "HistoryCell"
    var daysRange = Date.getDates(forLastNDays: 3)

    var messageLabelTitle: String {
        "Rates of conversion between \(convertUnit.from) and \(convertUnit.to) last 3 days"
    }
    
    init(repository: ConverterRepositoryType, convertUnit: ConvertUnit) {
        self.repository = repository
        self.convertUnit = convertUnit
    }
    
    func viewDidLoad() {
        getHistory()
    }
    
    private func getHistory() {
        stateSubject.accept(.loading)
                
        repository
            .getHistory(startDate: daysRange.last ?? "", endDate: daysRange.first ?? "", base: convertUnit.from, symbols: convertUnit.to)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.stateSubject.accept(response.rates.count > 0 ? .populated : .empty)
                let rates = response.rates.map {
                    HistoryRate(date: $0.key, rate: $0.value.first?.value ?? 0.0)
                }.sorted(by: { $0.date < $1.date })
                self.historySubject.accept(rates)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
