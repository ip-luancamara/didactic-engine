//
//  PFMMovementViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 26/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

protocol PFMMovementDisplayLogic {
    @MainActor func displayMovements(viewModel: PFMMovement.ShowMovements.ViewModel)
    @MainActor func displayModal(viewModel: PFMMovement.ShowModal.ViewModel)
    @MainActor func displayAllTransactions(viewModel: PFMMovement.ShowAllTransactions.ViewModel)
    @MainActor func displayTransactionDetails(viewModel: PFMMovement.TransactionDetails.ViewModel)
}

class PFMMovementViewController: UIViewController, PFMMovementDisplayLogic {

    var router: (PFMMovementDataPassing & PFMMovementRoutingLogic)?
    var interactor: (PFMMovementBusinessLogic & PFMMovementViewDelegate)?
    let theme = Theme()

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var mainView: PFMMovementView {
        guard let view = view as? PFMMovementView else { fatalError("MainView type error") }
        return view
    }

    lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = UDSColors.white.color
        view.text = I18n.movements.localized
        return view
    }()

    override func loadView() {
        super.loadView()
        view = PFMMovementView().setupView()
        mainView.actionDelegate = interactor
        mainView.mainStack.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        
        setNavigationBar(
            appearance: .primaryInverse,
            rightAction: #selector(
                didTapBringData
            ),
            rightIcon: UDSAssets.udsAdd.image
        )
        
        interactor?.showMovements(
            request: PFMMovement.ShowMovements.Request()
        )
    }

    private func setup() {
        let viewController = self

        let presenter = PFMMovementPresenter(
            viewController: self
        )

        let interactor = PFMMovementInteractor(
            presenter: presenter
        )

        let router = PFMMovementRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func displayMovements(viewModel: PFMMovement.ShowMovements.ViewModel) {
        mainView.setup(
            filterDate: viewModel.filterDate,
            totalExpenses: viewModel.totalExpenses,
            updatedAt: viewModel.updatedAt,
            expenses: viewModel.expenses
        )
        
        mainView.mainStack.isHidden = false
    }
    
    func displayModal(viewModel: PFMMovement.ShowModal.ViewModel) {
        router?.routeToFilterDate(modal: viewModel.viewController)
    }
    
    func displayAllTransactions(viewModel: PFMMovement.ShowAllTransactions.ViewModel) {
        mainView.setup(
            filterDate: viewModel.filterDate,
            totalExits: viewModel.totalExits,
            totalEntries: viewModel.totalEntries,
            total: viewModel.total,
            updatedAt: viewModel.updatedAt,
            movementTypeFilter: viewModel.movementTypeFilter.localized,
            balanceFilter: getBalanceFilter(for: viewModel.movementTypeFilter),
            expenses: viewModel.expenses
        )
    }
    
    func displayTransactionDetails(viewModel: PFMMovement.TransactionDetails.ViewModel) {
        router?.routeToTransactionDetails()
    }
    
    @objc func didTapBringData() {
        let bottomSheetViewController = PFMRedirectViewController()

        let modalViewController = UDSBottomSheetViewController(
            viewModel: UDSBottomSheetViewModel(
                childViewController: bottomSheetViewController
            )
        )
        
        bottomSheetViewController.dismissAction = {
            modalViewController.dismiss(animated: true)
        }
        
        present(
            modalViewController,
            animated: true
        )
    }
    
    private func getBalanceFilter(for title: I18n) -> BalanceResumeFilterType {
        switch title {
        case .entries:
            return .entries
        case .exits:
            return .exits
        default:
            return .none
        }
    }
}
