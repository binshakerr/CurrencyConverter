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

//    func test_getCurrencies_success() {
//        // Given
//        currenciesData = Utils.MockResponseType.CurrenciesSuccessResponse.sampleDataFor(self)
//        let decodedItem = try? JSONDecoder().decode(CurrenciesContainerResponse.self, from: currenciesData)
//        converterRepository.currenciesStubData = decodedItem?.symbols.map {
//            CurrencySymbol(symbol: $0.key, fullName: $0.value)
//        }
//
//        // When
//        let searchObserver = scheduler.createObserver([CurrencySymbol].self)
//        converterViewModel
//            .outputs
//            .currencySubject
//            .bind(to: searchObserver)
//            .disposed(by: disposeBag)
//        scheduler
//            .createColdObservable([.next(10, "horse")])
//            .bind(to: converterViewModel.inputs.viewDidLoad())
//            .disposed(by: disposeBag)
//        scheduler.start()
//
//        // Then
//        let searchElement = searchObserver.events.last?.value.element
//        XCTAssertEqual(searchElement?.count, 184)
//    }

    
}
