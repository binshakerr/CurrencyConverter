//
//  HistoryViewController.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.register(UINib(nibName: viewModel.cellId, bundle: nil), forCellReuseIdentifier: viewModel.cellId)
        }
    }
    
    private let viewModel: HistoryViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: HistoryViewModelProtocol) {
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
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        navigationItem.title = viewModel.outputs.screenTitle
        messageLabel.text = viewModel.outputs.messageLabelTitle
    }
    
    private func bindViewModel() {
        bindOutputs()
    }
    
    func bindOutputs() {
        
        viewModel
            .outputs
            .stateSubject
            .subscribe(onNext:  { [weak self] state in
                guard let self = self else { return }
                state == .loading ? self.startLoading() : self.stopLoading()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .errorSubject
            .subscribe(onNext:  { [weak self] message in
                guard let self = self, let message = message else { return }
                self.showSimpleAlert(title: "Error", message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .historySubject
            .bind(to: historyTableView
                .rx
                .items(cellIdentifier: viewModel.cellId, cellType: HistoryCell.self)) { (items, object, cell) in
                    cell.history = object
                }
                .disposed(by: disposeBag)
    }
    
}
