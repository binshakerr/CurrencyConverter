//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Eslam Shaker on 16/11/2022.
//

import XCTest
import RxSwift
import RxTest
@testable import CurrencyConverter

final class CurrencyConverterTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var converterViewModel: ConverterViewModelProtocol!
    var currenciesData: Data!
    var conversionData: Data!
    var historyViewModel: HistoryViewModelProtocol!
    var historyData: Data!
    var converterRepository: MockConverterRepository!
    let timeOut: Double = 10
    var convertUnit: ConvertUnit!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        converterRepository = MockConverterRepository()
        converterViewModel = ConverterViewModel(repository: converterRepository)
        convertUnit = ConvertUnit(from: "", to: "", amount: 1.0)
        historyViewModel = HistoryViewModel(repository: converterRepository, convertUnit: convertUnit)
    }

    override func tearDown() {
        converterViewModel = nil
        currenciesData = nil
        conversionData = nil

        historyViewModel = nil
        historyData = nil

        converterRepository = nil
    }

    func test_converterViewModel_initialState() {
        XCTAssertTrue(converterViewModel.outputs.currencySubject.value.isEmpty)
        XCTAssertEqual(converterViewModel.outputs.screenTitle, "Currency Converter")
    }

    func test_getCurrencies_success() {
        // Given
        currenciesData = Utils.MockResponseType.CurrenciesSuccessResponse.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(CurrenciesContainerResponse.self, from: currenciesData)
        converterRepository.currenciesStubData = decodedItem?.symbols.map {
            CurrencySymbol(symbol: $0.key, fullName: $0.value)
        }

        // When
        let currencyObserver = scheduler.createObserver([CurrencySymbol].self)
        converterViewModel
            .outputs
            .currencySubject
            .bind(to: currencyObserver)
            .disposed(by: disposeBag)
        converterViewModel.inputs.viewDidLoad()
        scheduler.start()

        // Then
        let currencyElement = currencyObserver.events.last?.value.element
        XCTAssertEqual(currencyElement?.count, 169)
    }
    
    func test_convertCurrency_success() {
        // Given
        convertUnit = ConvertUnit(from: "USD", to: "EGP", amount: 1.0)
        conversionData = Utils.MockResponseType.ConvertSuccessResponse.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(ConvertResult.self, from: conversionData)
        converterRepository.convertStubData = decodedItem
        
        // When
        let convertObserver = scheduler.createObserver(Double.self)
        converterViewModel
            .outputs
            .conversionSubject
            .bind(to: convertObserver)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(1, convertUnit)])
            .bind(to: converterViewModel.inputs.converterUnitSubject)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        let convertElement = convertObserver.events.last?.value.element
        XCTAssertEqual(convertElement, 24.514904)
    }

    func test_convertCurrency_wrongAmount_failure() {
        // Given
        convertUnit = ConvertUnit(from: "USD", to: "EGP", amount: 0)
        conversionData = Utils.MockResponseType.ConvertWrongAmountResponse.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(ConvertResult.self, from: conversionData)
        converterRepository.convertStubData = decodedItem
        
        // When
        let convertObserver = scheduler.createObserver(Double.self)
        converterViewModel
            .outputs
            .conversionSubject
            .bind(to: convertObserver)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(1, convertUnit)])
            .bind(to: converterViewModel.inputs.converterUnitSubject)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        let convertElement = convertObserver.events.last?.value.element
        XCTAssertEqual(convertElement, 0)
    }
    
    func test_historyViewModel_initialState() {
        XCTAssertTrue(historyViewModel.outputs.historySubject.value.isEmpty)
        XCTAssertEqual(historyViewModel.outputs.screenTitle, "History")
    }
    
    func test_history_success() {
        // Given
        convertUnit = ConvertUnit(from: "USD", to: "EGP", amount: 1.0)
        historyData = Utils.MockResponseType.HistorySuccessResponse.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(HistoryResponse.self, from: historyData)
        converterRepository.historyStubData = decodedItem
        
        // When
        let historyObserver = scheduler.createObserver([HistoryRate].self)
        historyViewModel
            .outputs
            .historySubject
            .bind(to: historyObserver)
            .disposed(by: disposeBag)
        historyViewModel.inputs.viewDidLoad()
        scheduler.start()

        // Then
        let historyElement = historyObserver.events.last?.value.element
        XCTAssertEqual(historyElement?.count, 3)
        XCTAssert(historyElement?.first?.date ?? "" < historyElement?.last?.date ?? "")
    }
    
    func test_history_wrongDate_failure() {
        // Given
        convertUnit = ConvertUnit(from: "USD", to: "EGP", amount: 1.0)
        historyData = Utils.MockResponseType.HistoryWrongDateResponse.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(HistoryResponse.self, from: historyData)
        converterRepository.historyStubData = decodedItem
        
        // When
        let historyObserver = scheduler.createObserver([HistoryRate].self)
        historyViewModel
            .outputs
            .historySubject
            .bind(to: historyObserver)
            .disposed(by: disposeBag)
        historyViewModel.daysRange = ["2022-11-16", "2022-11-17", "2022-11-18"]
        historyViewModel.inputs.viewDidLoad()
        scheduler.start()

        // Then
        let historyElement = historyObserver.events.last?.value.element
        XCTAssertEqual(historyElement?.count, 0)
    }
    
}
