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
    @IBOutlet weak var detailsButton: UIButton!
    
    //MARK: - Properties
    private let viewModel: ConverterViewModelProtocol
    private let disposeBag = DisposeBag()
    private var fromCurrencyDropdown: DropDown!
    private var toCurrencyDropdown: DropDown!
    private var fromDropDownExpanded = false
    private var toDropDownExpanded = false
    private var convertUnit = ConvertUnit(from: "", to: "", amount: 1.0) {
        didSet {
            guard convertUnit.from.suffix(3).count > 0 &&
            convertUnit.to.suffix(3).count > 0 &&
            convertUnit.amount > 0 else {
                changeDetailsButtonApperance(enabled: false)
                return
            }
            
            changeDetailsButtonApperance(enabled: true)
        }
    }
    
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
        viewModel.inputs.viewDidLoad()
    }
    
    //MARK: -
    
    private func setupUI() {
        navigationItem.title = viewModel.outputs.screenTitle
        setupDropdowns()
        changeDetailsButtonApperance(enabled: false)
    }
    
    private func setupDropdowns() {
        let fromTap = UITapGestureRecognizer(target: self, action: #selector(toggleFromDropdown))
        fromCurrencyDropdownTextField.addGestureRecognizer(fromTap)
        
        fromCurrencyDropdown = DropDown()
        fromCurrencyDropdown.anchorView = fromCurrencyDropdownTextField
        fromCurrencyDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.fromCurrencyDropdownTextField.text = item
            self.convertUnit.from = String(item.prefix(3))
            self.viewModel.converterUnitSubject.accept(self.convertUnit)
        }
        
        let toTap = UITapGestureRecognizer(target: self, action: #selector(toggleToDropdown))
        toCurrencyDropdownTextField.addGestureRecognizer(toTap)
        
        toCurrencyDropdown = DropDown()
        toCurrencyDropdown.anchorView = toCurrencyDropdownTextField
        toCurrencyDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.toCurrencyDropdownTextField.text = item
            self.convertUnit.to = String(item.prefix(3))
            self.viewModel.converterUnitSubject.accept(self.convertUnit)
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
        
        viewModel.outputs.currencySubject
            .subscribe(onNext:  { [weak self] symbols in
                guard let self = self else { return }
                let strings = symbols.map {
                    "\($0.symbol) - \($0.fullName)"
                }
                self.fromCurrencyDropdown.dataSource = strings
                self.toCurrencyDropdown.dataSource = strings
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.conversionSubject
            .subscribe(onNext:  { [weak self] result in
                guard let self = self else { return }
                self.toValueTextField.text = "\(result)"
            })
            .disposed(by: disposeBag)
    }
    
    private func changeDetailsButtonApperance(enabled: Bool) {
        detailsButton.isUserInteractionEnabled = enabled
        detailsButton.backgroundColor = enabled ? .systemIndigo: .gray
    }
    
    private func navigateToDetails() {
        let repository = ConverterRepository(networkManager: NetworkManager.shared)
        let viewModel = HistoryViewModel(repository: repository, convertUnit: convertUnit)
        let controller = HistoryViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Actions
    @IBAction func swapButtonPressed(_ sender: Any) {
        
        let from = convertUnit.from
        let to = convertUnit.to
        
        fromCurrencyDropdownTextField.text = to
        toCurrencyDropdownTextField.text = from
        
        convertUnit.from = to
        convertUnit.to = from
        
        viewModel.inputs.converterUnitSubject.accept(convertUnit)
    }
    
    
    @IBAction func fromValueFieldChanged(_ sender: Any) {
        convertUnit.amount = ((fromValueTextField.text ?? "") as NSString).floatValue
        viewModel.inputs.converterUnitSubject.accept(convertUnit)
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        navigateToDetails()
    }
    
}
