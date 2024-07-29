//
//  PFMViewController.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 15/02/24.
//

import Foundation
import UIKit
import NetworkSdk
@_implementationOnly import DesignSystem

protocol PFMDisplayLogic {
    @MainActor func displayLinks(viewModel: PFM.LoadView.ViewModel)
    @MainActor func displayLoading()
    @MainActor func displaySelectedService(viewModel: PFM.SelectService.ViewModel)
    @MainActor func displayFeedbackView(viewModel: PFM.Feedback.ViewModel)
    @MainActor func displayTransactionsByCategory(viewModel: PFM.TransactionsByCategory.ViewModel)
    @MainActor func displayExpenses(viewModel: PFM.AccessAll.ViewModel)
    @MainActor func displayMovements(viewModel: PFM.Movements.ViewModel)
    @MainActor func displayModal(viewModel: PFM.Modal.ViewModel)
}

class PFMViewController: UIViewController, PFMDisplayLogic {

    let theme = Theme()
    var router: (PFMDataPassing & PFMRoutingLogic)?
    var interactor: (PFMBusinessLogic & UDSBalanceCreditCardViewModelDelegate & SpendingCarroucelDelegate & ChartsCarroucelDelegate)?
    let logger: PFMLoggerProtocol
    
    var canMakeNetworkRequest = false {
        didSet {
            guard canMakeNetworkRequest else { return }
            interactor?.getData(request: PFM.LoadView.Request())
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            mainView.isLoading = isLoading
            mainView.reloadData()
        }
    }

    var isValuesHidden = false {
        didSet {
            setNavigationBar(
                appearance: .primaryInverse,
                rightIcon: isValuesHidden ? UDSAssets.udsEyeClosed.image : UDSAssets.udsEye.image
            )

            mainView.hideValues = isValuesHidden
            
            mainView.cardsCollection.setup(
                with: cards,
                delegate: interactor
            )
            
            mainView.reloadData()
        }
    }

    var accounts: [Account] = []
    var cards: [CreditCard] = []

    var insights: [Insight] {
        guard isValuesHidden else { return unhiddenValuesInsigths }
        return hiddenValuesInsigths
    }

    var hiddenValuesInsigths: [Insight] {
        unhiddenValuesInsigths.map({ $0.hidden() })
    }

    var unhiddenValuesInsigths: [Insight] = []
    
    var cameFromViewDidLoad: Bool = false

    init(
        logger: PFMLoggerProtocol = PFMLogger(
            className: PFMViewController.self
        )
    ) {
        self.logger = logger
        super.init(
            nibName: nil,
            bundle: nil
        )
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var mainView: PFMView {
        guard let view = view as? PFMView else { fatalError("MainView type error") }
        return view
    }

    lazy var titleView: UILabel = {
        let view = UILabel()
        view.text = I18n.financialManager.localized
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = UDSColors.white.color
        view.accessibilityTraits = .header
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.backgroundColor.secondary
        navigationItem.titleView = titleView
        
        setNavigationBar(
            appearance: .primaryInverse,
            rightAction: #selector(
                showDetails
            ),
            rightIcon: UDSAssets.udsEye.image
        )
        
        navigationItem.leftBarButtonItem?.accessibilityLabel = "Voltar"
        navigationItem.rightBarButtonItem?.accessibilityLabel = "Esconder valores"

        mainView.collectionViewDelegate = self
        mainView.collectionViewDataSource = self
        mainView.chartsDelegate = interactor
        mainView.spendingView.delegate = interactor
        mainView.reloadData()
        
        cameFromViewDidLoad = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !cameFromViewDidLoad {
            interactor?.getData(request: PFM.LoadView.Request())
            cameFromViewDidLoad = false
        }
    }

    @objc func showDetails() {
        isValuesHidden.toggle()
        navigationItem.rightBarButtonItem?.accessibilityLabel = isValuesHidden ? "Mostrar valores" : "Esconder valores"
    }

    override func loadView() {
        view = PFMView().setupView()
    }

    // MARK: Setup

    private func setup() {
        logger.log("Setting up VIP cycle")
        let viewController = self
        let presenter = PFMPresenter(
            viewController: self
        )
        let worker = PFMWorker()
        let interactor = PFMInteractor(
            worker: worker,
            presenter: presenter
        )

        let router = PFMRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }

    func displayLinks(
        viewModel: PFM.LoadView.ViewModel
    ) {
        accounts = viewModel.accounts

        unhiddenValuesInsigths = viewModel.insights
        
        cards = viewModel.cards

        mainView.cardsCollection.setup(
            with: viewModel.cards,
            delegate: interactor
        )

        mainView.setup(
            accountsBalance: viewModel.allAccountsBalance,
            cardsBalance: viewModel.allCardsBalance
        )

        mainView.chartsCaroucel.setup(with: viewModel.charts)

        mainView.spendingView.setup(with: viewModel.spendings, shouldResetScroll: cameFromViewDidLoad)
        
        mainView.myExpensesHeading.delegate = self

        isLoading = false
        
        if cameFromViewDidLoad { cameFromViewDidLoad.toggle() }
    }

    func displayLoading() {
        isLoading = true
    }

    func displaySelectedService(viewModel: PFM.SelectService.ViewModel) {
        router?.routeToServiceDetails()
    }
    
    func displayFeedbackView(viewModel: PFM.Feedback.ViewModel) {
        router?.routeToFeedback(type: viewModel.type)
    }
    
    func displayTransactionsByCategory(viewModel: PFM.TransactionsByCategory.ViewModel) {
        router?.routeToTransactionsByCategory(
            month: viewModel.month,
            year: viewModel.year,
            categoryId: viewModel.categoryId
        )
    }
    
    func displayExpenses(viewModel: PFM.AccessAll.ViewModel) {
        router?.routeToExpenses(
            month: viewModel.month,
            year: viewModel.year
        )
    }
    
    func displayMovements(viewModel: PFM.Movements.ViewModel) {
        router?.routeToMovements(
            month: viewModel.month,
            year: viewModel.year
        )
    }
    
    func displayModal(viewModel: PFM.Modal.ViewModel) {
        present(viewModel.viewController, animated: true)
    }
}

extension PFMViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard !isLoading else { return 3 }
        
        let section = HomeSection(rawValue: collectionView.tag)

        switch section {
        case .expensesChart:
            return 1
        case .infos:
            return insights.endIndex
        case .accounts:
            return accounts.endIndex
        default:
            return 0
        }
    }

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int { 1 }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = HomeSection(rawValue: collectionView.tag)

        switch section {
        case .infos:
            let cell = collectionView.dequeueReusableCell(of: InfoCell.self, for: indexPath)
            
            guard !isLoading else { return cell.setupView().setup() }
            
            let info = insights[indexPath.item]
            
            return cell.setupView().setup(
                title: info.title,
                description: info.description,
                iconName: info.iconName
            )
        case .accounts:
            let cell = collectionView.dequeueReusableCell(of: BankAccountCell.self, for: indexPath)
            
            guard !isLoading else { return cell.setupView().setup() }
            
            let account = accounts[indexPath.item]
            
            return cell.setupView().setup(
                bankName: account.bankName,
                account: account.accountNumber,
                balance: account.balance,
                image: account.imageURL,
                isValuesHidden: isValuesHidden
            )
        case .cards, .expensesChart, .expensesList, nil:
            return UICollectionViewCell()
        }

    }
}

extension PFMViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let section = HomeSection(rawValue: collectionView.tag)

        switch section {
        case .expensesChart:
            return CGSize(width: UIScreen.main.bounds.width, height: 236)
        case .infos:
            return CGSize(width: 253, height: 102)
        case .accounts:
            return CGSize(width: 253, height: 80)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = HomeSection(rawValue: collectionView.tag)

        switch section {
        case .accounts:
            interactor?.selectAccount(request: PFM.SelectService.Request(index: indexPath.item))
        default:
            return
        }
    }
}

extension PFMViewController: UDSTypographySetHeadingDelegate {
    func didTapButton(_ button: UDSButtonTertiary) {			
        interactor?.didTapAccessAll(
            request: PFM.AccessAll.Request(
                index: mainView.spendingView.currentPage
            )
        )
    }
}
