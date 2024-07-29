//
//  PFMView.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 15/02/24.
//

import UIKit
@_implementationOnly import DesignSystem

class PFMView: UIScrollView, ViewCode, Loadable {
    
    weak var chartsDelegate: ChartsCarroucelDelegate? {
        didSet {
            chartsCaroucel.delegate = chartsDelegate
        }
    }

    let theme = Theme()

    var hideValues: Bool = false {
        didSet {
            cardsCollection.hideValues = hideValues
            chartsCaroucel.hideValues = hideValues
            accountsHeader.hideValues = hideValues
            spendingView.hideValues = hideValues
            reloadData()
        }
    }

    var collectionViewDelegate: UICollectionViewDelegate? {
        didSet {
            infosCollection.delegate = collectionViewDelegate
            accountsCollection.delegate = collectionViewDelegate
        }
    }

    var collectionViewDataSource: UICollectionViewDataSource? {
        didSet {
            infosCollection.dataSource = collectionViewDataSource
            accountsCollection.dataSource = collectionViewDataSource
        }
    }

    func reloadData() {
        infosCollection.reloadData()
        accountsCollection.reloadData()
    }

    func setup(
        accountsBalance: Double,
        cardsBalance: Double
    ) {
        accountsHeader.setup(
            title: .checkingAccount,
            subtitle: .totalBalance,
            balance: accountsBalance
        )
        
        cardsCollection.cardsHeader.setup(
            title: .myCards,
            subtitle: .openStatements,
            balance: cardsBalance
        )
    }

    // MARK: Properties
    lazy var container: UIStackView = {
        let view = UIStackView(
            arrangedSubviews: [
                chartsCaroucel,
                infosCollection,
                accountsHeader,
                accountsCollection,
                cardsCollection,
                myExpensesHeadingStack,
                spendingView,
                infoParagraph,
                spacer
            ]
        )
        view.axis = .vertical
        view.alignment = .center
        return view
    }()

    lazy var chartsCaroucel: ChartsCarroucel = {
        ChartsCarroucel().setupView()
    }()

    lazy var heading: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(
            customTopAnchor: 20,
            customBottomAnchor: 20
        )

        view.configure(
            headingText: I18n.myExpenses.localized,
            headingColor: .green700
        )

        return view
    }()

    lazy var accountsHeader: BalanceHeaderView = {
        BalanceHeaderView().setupView()
    }()

    lazy var spendingView: SpendingCaroucel = {
        SpendingCaroucel().setupView()
    }()
    
    lazy var myExpensesHeadingStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [myExpensesHeading])
        view.layoutMargins = .init(x: 16)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    lazy var myExpensesHeading: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(
            customTopAnchor: 24,
            customBottomAnchor: 20,
            labelStyle: .small
        )

        view.configure(
            headingText: I18n.myOutgoings.localized,
            headingColor: .grey900
        )
        
        view.configure(buttonTitle: I18n.accessAll.localized)

        return view
    }()

    lazy var spacer = UIView()

    lazy var infosCollection: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 16
        flow.minimumLineSpacing = 16
        flow.sectionInset = UIEdgeInsets(x: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
        view.showsHorizontalScrollIndicator = false
        view.tag = HomeSection.infos.rawValue
        view.backgroundColor = .clear
        view.anchor(height: 108)
        return view
    }()

    lazy var accountsCollection: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 16
        flow.minimumLineSpacing = 16
        flow.sectionInset = UIEdgeInsets(x: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
        view.showsHorizontalScrollIndicator = false
        view.tag = HomeSection.accounts.rawValue
        view.backgroundColor = .clear
        view.anchor(height: 92)
        return view
    }()

    lazy var cardsCollection: CreditCardCaroucel = {
        let view = CreditCardCaroucel().setupView()
        view.hideValues = hideValues
        return view
    }()

    lazy var infoParagraph: UIStackView = {
        let view = UIStackView(arrangedSubviews: [infoLabel])
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16)
        return view
    }()

    lazy var infoLabel: UDSTypographySetDescription = {
        let view = UDSTypographySetDescription(
            style: .small
        )
        view.configure(
            paragraphText: I18n.mainViewInfoTitle.localized,
            descriptorText: I18n.mainViewInfoSubtitle.localized
        )
        return view
    }()

    var isLoading: Bool = false {
        didSet {
            guard isLoading else {
                hideLoading()
                return
            }
            
            showLoading()
        }
    }
    
    func showLoading() {
        chartsCaroucel.isLoading = true
        accountsHeader.isLoading = true
        cardsCollection.isLoading = true
    }
    
    func hideLoading() {
        chartsCaroucel.isLoading = false
        accountsHeader.isLoading = false
        cardsCollection.isLoading = false
    }

    // MARK: Private Methods

    private func registerCollectionViewCells() {
        infosCollection.register(InfoCell.self)
        accountsCollection.register(BankAccountCell.self)
    }

    func buildViewHierachy() {
        addSubview(container)
    }

    func addContraints() {

        container.anchor(
            top: contentLayoutGuide.topAnchor,
            left: safeAreaLayoutGuide.leftAnchor,
            bottom: contentLayoutGuide.bottomAnchor,
            right: safeAreaLayoutGuide.rightAnchor
        )

        [
            chartsCaroucel,
            infosCollection,
            accountsHeader,
            accountsCollection,
            cardsCollection,
            myExpensesHeadingStack,
            spendingView,
            infoParagraph
        ].forEach({
            $0.anchor(
                left: container.leftAnchor,
                right: container.rightAnchor
            )
        })
    }

    func addAdditionalConfiguration() {
        registerCollectionViewCells()
        showsVerticalScrollIndicator = false
        container.setCustomSpacing(20, after: chartsCaroucel)
        container.setCustomSpacing(20, after: accountsHeader)
        container.setCustomSpacing(24, after: spendingView)
        spacer.anchor(height: 24)
    }
}
