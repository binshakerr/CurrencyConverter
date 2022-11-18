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
    private let viewModel: ConverterViewModel
    private let disposeBag = DisposeBag()
    private var fromCurrencyDropdown: DropDown!
    private var toCurrencyDropdown: DropDown!
    private var fromDropDownExpanded = false
    private var toDropDownExpanded = false
    
    //MARK: - Life cycle
    init(viewModel: ConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: -
    
    private func setupUI() {
        navigationItem.title = "Currency Converter"
        setupDropdowns()
    }
    
    private func setupDropdowns() {
        let fromTap = UITapGestureRecognizer(target: self, action: #selector(toggleFromDropdown))
        fromCurrencyDropdownTextField.addGestureRecognizer(fromTap)
        
        fromCurrencyDropdown = DropDown()
        fromCurrencyDropdown.anchorView = fromCurrencyDropdownTextField
        fromCurrencyDropdown.dataSource = ["Car", "Motorcycle", "Truck"]
        fromCurrencyDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self?.fromCurrencyDropdownTextField.text = item
        }
        
        let toTap = UITapGestureRecognizer(target: self, action: #selector(toggleToDropdown))
        toCurrencyDropdownTextField.addGestureRecognizer(toTap)
        
        toCurrencyDropdown = DropDown()
        toCurrencyDropdown.anchorView = toCurrencyDropdownTextField
        toCurrencyDropdown.dataSource = ["Cat", "Dog", "Horse"]
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
    
    
    //MARK: - Actions
    @IBAction func swapButtonPressed(_ sender: Any) {
        
    }
    
    
}
