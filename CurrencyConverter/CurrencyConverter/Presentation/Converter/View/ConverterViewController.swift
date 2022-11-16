//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import UIKit

class ConverterViewController: UIViewController {

    private let viewModel: ConverterViewModel
    
    init(viewModel: ConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
