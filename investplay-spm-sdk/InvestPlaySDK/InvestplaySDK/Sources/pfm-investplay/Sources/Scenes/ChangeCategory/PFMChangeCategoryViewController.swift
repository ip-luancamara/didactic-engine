//
//  PFMChangeCategoryViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
import NetworkSdk
@_implementationOnly import DesignSystem

protocol PFMChangeCategoryDisplayLogic: AnyObject {
    @MainActor func displayChangeCategory(viewModel: PFMChangeCategory.ChangeCategory.ViewModel)
    @MainActor func displayCategories(viewModel: PFMChangeCategory.GetCategories.ViewModel)
    @MainActor func displayLoading(viewModel: PFMChangeCategory.Loading.ViewModel)
}

class PFMChangeCategoryViewController: UIViewController, PFMChangeCategoryDisplayLogic {
    
    var interactor: PFMChangeCategoryBusinessLogic?
    var router: (NSObjectProtocol & PFMChangeCategoryRoutingLogic & PFMChangeCategoryDataPassing)?
    
    weak var delegate: PFMTransactionDetailsSnackbarDelegate?
    
    var mainView: PFMChangeCategoryView {
        guard let view = view as? PFMChangeCategoryView else { fatalError("MainView type error") }
        return view
    }
    
    var categories: [IdentifiableSpendingViewModel] = []

    lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = UDSColors.white.color
        view.text = I18n.changeCategory.localized
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
        let interactor = PFMChangeCategoryInteractor()
        let presenter = PFMChangeCategoryPresenter()
        let router = PFMChangeCategoryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        view = PFMChangeCategoryView().setupView()
        mainView.searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getCategories(request: PFMChangeCategory.GetCategories.Request())
        
        navigationItem.titleView = titleView
        setNavigationBar(
            appearance: .primaryInverse
        )
    }
    
    func displayChangeCategory(
        viewModel: PFMChangeCategory.ChangeCategory.ViewModel
    ) {
        defer {
            mainView.isLoading = false
        }
        
        guard viewModel.success else {
            mainView.errorAlert.isHidden = false
            return
        }
        
        router?.routeToTransactionDetails { [weak self] in
            guard let self else { return }
            delegate?.showSuccessSnackbar()
        }
    }
    
    func displayCategories(
        viewModel: PFMChangeCategory.GetCategories.ViewModel
    ) {
        categories = viewModel.categories
        mainView.setup(
            with: viewModel.categories,
            selectedCategory: viewModel.selectedCategoryName
        )
    }
    
    func displayLoading(
        viewModel: PFMChangeCategory.Loading.ViewModel
    ) {
        mainView.isLoading = true
    }
}

extension PFMChangeCategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            mainView.setup(
                with: categories
            )
            return
        }
        
        mainView.setup(
            with: categories.filter { $0.viewModel.title.lowercased().contains(searchText.lowercased()) }
        )
    }
}
