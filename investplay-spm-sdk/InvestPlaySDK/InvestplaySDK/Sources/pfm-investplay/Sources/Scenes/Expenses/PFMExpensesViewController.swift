//
//  PFMExpensesViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 07/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

protocol PFMExpensesDisplayLogic {
    func displayCategories(viewModel: PFMExpenses.ShowCategories.ViewModel)
    func displayDateSelectModal(viewModel: PFMExpenses.FilterDate.ViewModel)
}

class PFMExpensesViewController: UIViewController, PFMExpensesDisplayLogic {

    var router: (PFMExpensesDataPassing & PFMExpensesRoutingLogic)?
    var interactor: (PFMExpensesBusinessLogic & PFMExpensesViewDelegate)?
    let theme = Theme()

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var mainView: PFMExpensesView {
        guard let view = view as? PFMExpensesView else { fatalError("MainView type error") }
        return view
    }

    lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = UDSColors.white.color
        view.text = I18n.myOutgoings.localized
        return view
    }()

    override func loadView() {
        super.loadView()
        view = PFMExpensesView().setupView()
        mainView.actionDelegate = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        
        setNavigationBar(
            appearance: .primaryInverse
        )
        
        interactor?.showCategories(
            request: PFMExpenses.ShowCategories.Request()
        )
    }

    private func setup() {
        let viewController = self

        let presenter = PFMExpensesPresenter(
            viewController: self
        )

        let interactor = PFMExpensesInteractor(
            presenter: presenter
        )

        let router = PFMExpensesRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func displayCategories(viewModel: PFMExpenses.ShowCategories.ViewModel) {
        mainView.setup(
            filterDate: viewModel.filterDate,
            totalSpent: viewModel.totalExpenses,
            spendingsCategories: viewModel.categories
        )
        
        mainView.spendingChartList.arrangedSubviews.forEach({
            $0.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(
                        didTapSpendingChart
                    )
                )
            )
        })
    }
    
    func displayDateSelectModal(viewModel: PFMExpenses.FilterDate.ViewModel) {
        router?.routeToFilterDate(modal: viewModel.viewController)
    }
    
    @objc func didTapSpendingChart(_ sender: UITapGestureRecognizer) {
        guard let id = sender.view?.accessibilityIdentifier else { return }
        router?.routeToTransactionsByCategory(categoryId: id)
    }
}
