//
//  PFMCategoryTransactionsViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 26/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

protocol PFMCategoryTransactionsDisplayLogic {
    @MainActor func displayMovements(viewModel: PFMCategoryTransactions.ShowMovements.ViewModel)
    @MainActor func displayTransactionDetails(viewModel: PFMCategoryTransactions.TransactionDetails.ViewModel)
}

class PFMCategoryTransactionsViewController: UIViewController, PFMCategoryTransactionsDisplayLogic {

    var router: (PFMCategoryTransactionsDataPassing & PFMCategoryTransactionsRoutingLogic)?
    var interactor: (PFMCategoryTransactionsBusinessLogic)?
    let theme = Theme()

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var mainView: PFMCategoryTransactionsView {
        guard let view = view as? PFMCategoryTransactionsView else { fatalError("MainView type error") }
        return view
    }

    lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = UDSColors.white.color
        return view
    }()

    override func loadView() {
        super.loadView()
        view = PFMCategoryTransactionsView().setupView()
        mainView.mainStack.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        
        setNavigationBar(
            appearance: .primaryInverse,
            rightAction: #selector(
                addAccount
            )
        )
        
        interactor?.showMovements(
            request: PFMCategoryTransactions.ShowMovements.Request()
        )
    }

    private func setup() {
        let viewController = self

        let presenter = PFMCategoryTransactionsPresenter(
            viewController: self
        )

        let interactor = PFMCategoryTransactionsInteractor(
            presenter: presenter
        )

        let router = PFMCategoryTransactionsRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }

    @objc func addAccount() {
        Investplay.delegate?.didTapRightButton(on: .movements)
    }
    
    func displayMovements(
        viewModel: PFMCategoryTransactions.ShowMovements.ViewModel
    ) {
        titleView.text = viewModel.selectedCategory
        
        mainView.setup(
            filterDate: viewModel.filterDate,
            totalExpenses: viewModel.totalExpenses,
            expenses: viewModel.expenses
        )
        
        mainView.mainStack.isHidden = false
    
    }
    
    func displayTransactionDetails(viewModel: PFMCategoryTransactions.TransactionDetails.ViewModel) {
        router?.routeToTransactionDetails()
    }
}
