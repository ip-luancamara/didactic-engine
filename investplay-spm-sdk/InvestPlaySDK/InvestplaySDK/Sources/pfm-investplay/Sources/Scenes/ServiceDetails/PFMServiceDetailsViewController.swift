//
//  PFMServiceDetailsViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 10/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

protocol PFMServiceDetailsDisplayLogic: AnyObject {
    @MainActor func displayDetails(viewModel: PFMServiceDetails.ShowServiceDetails.ViewModel)
    @MainActor func displayModal(viewModel: PFMServiceDetails.ServiceModal.ViewModel)
    @MainActor func displayTransactionDetails(viewModel: PFMServiceDetails.TransactionDetails.ViewModel)
}

class PFMServiceDetailsViewController: UIViewController, PFMServiceDetailsDisplayLogic {

    var router: (PFMServiceDetailsDataPassing & PFMServiceDetailsRoutingLogic)?
    var interactor: (PFMServiceDetailsBusinessLogic & PFMServiceDetailsDelegate)?
    let theme = Theme()

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var mainView: PFMServiceDetailsView {
        guard let view = view as? PFMServiceDetailsView else { fatalError("MainView type error") }
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
        view = PFMServiceDetailsView().setupView()
        mainView.actionDelegate = interactor
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

        interactor?.showDetails(
            request: PFMServiceDetails.ShowServiceDetails.Request(dateFilter: .current)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        interactor?.refetchData(request: PFMServiceDetails.RefetchData.Request())
    }
    
    private func setup() {
        let viewController = self

        let presenter = PFMServiceDetailsPresenter(
            viewController: self
        )

        let interactor = PFMServiceDetailsInteractor(
            presenter: presenter
        )

        let router = PFMServiceDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func displayDetails(
        viewModel: PFMServiceDetails.ShowServiceDetails.ViewModel
    ) {
        mainView.setup(
            for: viewModel.type,
            month: viewModel.month,
            year: viewModel.year,
            spendings: viewModel.transactions,
            totalEntries: viewModel.totalEntries,
            totalExits: viewModel.totalExits,
            monthBalance: viewModel.balance,
            updatedAt: viewModel.updatedAt,
            movementChipTitle: viewModel.movementFilterTitle
        )

        titleView.text = viewModel.screenTitle
    }

    func displayModal(
        viewModel: PFMServiceDetails.ServiceModal.ViewModel
    ) {
        present(
            viewModel.viewController,
            animated: false
        )
    }
    
    func displayTransactionDetails(viewModel: PFMServiceDetails.TransactionDetails.ViewModel) {
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
}
