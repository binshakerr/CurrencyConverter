//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class ConverterViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var fromCurrencyDropdownTextField: UITextField!
    @IBOutlet weak var toCurrencyDropdownTextField: UITextField!
    @IBOutlet weak var swapCurrencyButton: UIButton!
    @IBOutlet weak var fromValueTextField: UITextField!
    @IBOutlet weak var toValueTextField: UITextField!
    
    //MARK: - Properties
    private let viewModel: ConverterViewModelProtocol
    private let disposeBag = DisposeBag()
    private var fromCurrencyDropdown: DropDown!
    private var toCurrencyDropdown: DropDown!
    private var fromDropDownExpanded = false
    private var toDropDownExpanded = false
    
    //MARK: - Life cycle
    init(viewModel: ConverterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.getCurrencies()
    }
    
    //MARK: -
    
    private func setupUI() {
        navigationItem.title = viewModel.outputs.screenTitle
        setupDropdowns()
    }
    
    private func setupDropdowns() {
        let fromTap = UITapGestureRecognizer(target: self, action: #selector(toggleFromDropdown))
        fromCurrencyDropdownTextField.addGestureRecognizer(fromTap)
        
        fromCurrencyDropdown = DropDown()
        fromCurrencyDropdown.anchorView = fromCurrencyDropdownTextField
        fromCurrencyDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self?.fromCurrencyDropdownTextField.text = item
        }
        
        let toTap = UITapGestureRecognizer(target: self, action: #selector(toggleToDropdown))
        toCurrencyDropdownTextField.addGestureRecognizer(toTap)
        
        toCurrencyDropdown = DropDown()
        toCurrencyDropdown.anchorView = toCurrencyDropdownTextField
        toCurrencyDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self?.toCurrencyDropdownTextField.text = item
        }
    }
    
    @objc
    private func toggleFromDropdown() {
        toggleDropdown(fromCurrencyDropdown, expanded: fromDropDownExpanded)
        fromDropDownExpanded.toggle()
    }
    
    @objc
    private func toggleToDropdown() {
        toggleDropdown(toCurrencyDropdown, expanded: toDropDownExpanded)
        toDropDownExpanded.toggle()
    }
    
    private func toggleDropdown(_ dropdown: DropDown, expanded: Bool) {
        if expanded {
            dropdown.hide()
        } else {
            dropdown.show()
        }
    }
    
    private func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    func bindOutputs() {
       
        viewModel.outputs.stateSubject
            .subscribe(onNext:  { [weak self] state in
            guard let self = self else { return }
            state == .loading ? self.startLoading() : self.stopLoading()
        })
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorSubject
            .subscribe(onNext:  { [weak self] message in
            guard let self = self, let message = message else { return }
            self.showSimpleAlert(title: "Error", message: message)
        })
            .disposed(by: disposeBag)
        
        viewModel.outputs.dataSubject
            .subscribe(onNext:  { [weak self] symbols in
                guard let self = self else { return }
                let strings = symbols.map {
                    "\($0.symbol) - \($0.fullName)"
                }
                self.fromCurrencyDropdown.dataSource = strings
                self.toCurrencyDropdown.dataSource = strings
            })
            .disposed(by: disposeBag)
    }
    
    func bindInputs() {
//        searchController.searchBar.rx.searchButtonClicked
//            .compactMap {self.searchController.searchBar.text}
//            .bind(to: viewModel.inputs.searchSubject)
//            .disposed(by: disposeBag)
//
//        searchTable.rx.itemSelected.subscribe(onNext: { [weak self] item in
//            self?.openPhotoDetails(item.row)
//        })
//            .disposed(by: disposeBag)
    }
    
    
    //MARK: - Actions
    @IBAction func swapButtonPressed(_ sender: Any) {
        
    }
    
    
}
