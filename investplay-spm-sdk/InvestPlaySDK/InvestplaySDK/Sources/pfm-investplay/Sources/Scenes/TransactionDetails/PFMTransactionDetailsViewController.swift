//
//  PFMTransactionDetailsViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
@_implementationOnly import DesignSystem

protocol PFMTransactionDetailsDisplayLogic: AnyObject {
    @MainActor func displayTransactionDetails(viewModel: PFMTransactionDetails.TransactionDetails.ViewModel)
    @MainActor func displayChangeCategory(viewModel: PFMTransactionDetails.ChangeCategory.ViewModel)
    @MainActor func displayChangedIgnoreSpendingFlag(viewModel: PFMTransactionDetails.ChangeIgnoreSpendingFlag.ViewModel)
}

protocol PFMTransactionDetailsSnackbarDelegate: AnyObject {
    func showSuccessSnackbar()
}

class PFMTransactionDetailsViewController: UIViewController, PFMTransactionDetailsDisplayLogic {
    
    var interactor: PFMTransactionDetailsBusinessLogic?
    var router: (NSObjectProtocol & PFMTransactionDetailsRoutingLogic & PFMTransactionDetailsDataPassing)?
    
    var mainView: PFMTransactionDetailsView {
        guard let view = view as? PFMTransactionDetailsView else { fatalError("MainView type error") }
        return view
    }

    lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = UDSColors.white.color
        view.text = I18n.transactionDetails.localized
        return view
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = PFMTransactionDetailsInteractor()
        let presenter = PFMTransactionDetailsPresenter()
        let router = PFMTransactionDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    
    // MARK: View lifecycle

    override func loadView() {
        view = PFMTransactionDetailsView().setupView()
        mainView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleView
        
        setNavigationBar(
            appearance: .primaryInverse
        )
        
        interactor?.fetchTransactionDetails(request: PFMTransactionDetails.TransactionDetails.Request())
    }
    
    func displayTransactionDetails(
        viewModel: PFMTransactionDetails.TransactionDetails.ViewModel
    ) {
        mainView.setup(
            type: viewModel.type,
            title: viewModel.title,
            value: viewModel.value,
            date: viewModel.date,
            fromTitle: viewModel.fromTitle,
            fromSubtitle: viewModel.fromSubtitle,
            fromImageURL: viewModel.fromImageURL,
            category: viewModel.category,
            isIgnored: viewModel.isIgnored
        )
    }
    
    func displayChangeCategory(
        viewModel: PFMTransactionDetails.ChangeCategory.ViewModel
    ) {
        router?.routeToChangeCategory(delegate: viewModel.delegate)
    }
    
    func displayChangedIgnoreSpendingFlag(
        viewModel: PFMTransactionDetails.ChangeIgnoreSpendingFlag.ViewModel
    ) {
        if !viewModel.success {
            mainView.switchView.isOn.toggle()
        }
        
        mainView.switchView.configure(appearence: .enabled)
    }
}

extension PFMTransactionDetailsViewController: UDSItemListSwitchViewModelDelegate {
    func didSelect(
        isOn: Bool
    ) {
        mainView.switchView.configure(appearence: .disabled)
        
        interactor?.changeIgnoreSpendingFlag(
            request: PFMTransactionDetails.ChangeIgnoreSpendingFlag.Request(
                shouldIgnore: isOn
            )
        )
    }
}

extension PFMTransactionDetailsViewController: PFMTransactionDetailsSnackbarDelegate {
    func showSuccessSnackbar() {
        mainView.snackbar.show()
    }
}
