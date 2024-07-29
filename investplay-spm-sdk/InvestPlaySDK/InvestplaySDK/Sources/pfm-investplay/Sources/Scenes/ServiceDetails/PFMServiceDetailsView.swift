//
//  PFMAccountDetailsView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 05/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

struct PFMAccountDetailsViewModel {
    let account: Account
    let month: Int
    let year: Int
    let balanceEntries: [Date: [UDSSpendingViewModel]]
}

protocol PFMServiceDetailsDelegate: AnyObject {
    func didTapServiceChip(selectedID: String)
    func didTapDateChip(selectedMonth: Int, selectedYear: Int)
    func didTapMovementTypeChip(selected: PFMMovementType?)
}

class PFMServiceDetailsView: UIScrollView, ViewCode {

    weak var actionDelegate: PFMServiceDetailsDelegate?
    
    var selectedServiceID: String?
    
    var selectedMonth: Int?
    var selectedYear: Int?
    
    var selectedMovementType: PFMMovementType?

    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            chipStack,
            creditCardContainer,
            accountView,
            balance,
            balanceOfMonthStack,
            updatedAtCard,
            spendingList,
            .spacer
        ])
        view.axis = .vertical
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16, y: 24)
        view.spacing = 16
        view.setCustomSpacing(0, after: balance)
        view.setCustomSpacing(20, after: balanceOfMonthStack)
        return view
    }()

    lazy var accountChipFilter: UDSChipMultipleSelection = {
        UDSChipMultipleSelection(titleText: "")
    }()

    lazy var dateChipFilter: UDSChipMultipleSelection = {
        UDSChipMultipleSelection(titleText: "")
    }()

    lazy var transactionsChipFilter: UDSChipMultipleSelection = {
        UDSChipMultipleSelection(titleText: I18n.movimentationType.localized)
    }()

    lazy var chipStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [chipStackPrimary, chipStackSecondary])
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()

    lazy var chipStackPrimary: UIStackView = {
        let view = UIStackView(arrangedSubviews: [accountChipFilter, dateChipFilter])
        view.spacing = 16
        return view
    }()

    lazy var chipStackSecondary: UIStackView = {
        let view = UIStackView(arrangedSubviews: [transactionsChipFilter])
        view.spacing = 16
        return view
    }()

    lazy var creditCardContainer: UDSContainerView = {
        UDSContainerView(style: .outlined, containerView: creditCard)
    }()

    lazy var creditCard: CreditCardView = {
        CreditCardView().setupView()
    }()

    lazy var balance: BalanceResume = {
        BalanceResume()
    }()

    lazy var balanceOfMonthLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.x_small
        view.numberOfLines = 1
        view.text = I18n.monthBalance.localized
        return view
    }()

    lazy var balanceOfMonthValue: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.x_small
        view.numberOfLines = 1
        return view
    }()

    lazy var balanceOfMonthStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            balanceOfMonthLabel,
            UIView(),
            balanceOfMonthValue
        ])
        view.anchor(height: 20)
        return view
    }()

    lazy var updatedAtCard: UDSCardText = {
        let view = UDSCardText()
        view.anchor(height: 56)
        return view
    }()
    
    lazy var noMovementsAlert: AlertView = {
        let view = AlertView()
        view.configure(
            with: AlertViewModel(
                titleText: I18n.noMovementsAlertTitle.localized,
                descriptionText: I18n.noMovementsAlertDescription.localized,
                alertStyle: .emptyState
            )
        )
        view.isHidden = true
        return view
    }()

    lazy var spendingList: SpendingListByDate = {
        SpendingListByDate()
    }()

    lazy var accountView: BankAccountView = {
        BankAccountView(style: .outlined).setupView()
    }()

    func buildViewHierachy() {
        addSubview(mainStack)
        mainStack.addSubview(noMovementsAlert)
    }

    func addContraints() {
        mainStack.anchorAllToXMargins()
        
        noMovementsAlert.anchor(
            top: updatedAtCard.bottomAnchor,
            left: mainStack.leftAnchor,
            right: mainStack.rightAnchor,
            paddingTop: 32
        )

        mainStack.anchor(
            top: contentLayoutGuide.topAnchor,
            left: safeAreaLayoutGuide.leftAnchor,
            bottom: contentLayoutGuide.bottomAnchor,
            right: safeAreaLayoutGuide.rightAnchor
        )

        mainStack.setCustomSpacing(20, after: creditCard)
    }

    func addAdditionalConfiguration() {
        showsVerticalScrollIndicator = false
        [
            accountChipFilter,
            dateChipFilter,
            transactionsChipFilter
        ].forEach {
            $0.addTarget(
                self,
                action: #selector(
                    didTapFilterButton
                ),
                for: .touchUpInside
            )
        }
        
        mainStack.isHidden = true
    }

    func setup(
        for type: PFMServiceType,
        month: Int,
        year: Int,
        spendings: TransactionsPerDateWithIdentifier,
        totalEntries: String,
        totalExits: String,
        monthBalance: String,
        updatedAt: String,
        movementChipTitle: I18n
    ) {
        [
            chipStackSecondary,
            balance,
            accountView,
            balanceOfMonthStack
        ].forEach({
            $0.isHidden = type.isCard
        })

        creditCardContainer.isHidden = !type.isCard

        switch type {
        case .account(let account):
            accountView.setup(
                bankName: account.bankName,
                account: account.accountNumber,
                balance: account.balance,
                image: account.imageURL
            )

            accountChipFilter.configure(
                titleText: "\(account.bankName) • \(account.accountNumber)"
            )
            
            selectedServiceID = account.id
            
        case .card(let card):
            creditCard.setup(with: card, hideValues: false)

            accountChipFilter.configure(
                titleText: "\(card.bankName) • Final \(card.endNumber)"
            )
            
            selectedServiceID = card.id
        }
        
        selectedMonth = month
        selectedYear = year

        spendingList.setup(with: spendings)

        updatedAtCard.configure(
            with: UDSCardTextViewModel(
                subtitleDescription: updatedAt,
                icon: UDSAssets.udsOpen,
                style: .secondary
            )
        )

        dateChipFilter.configure(
            titleText: "\(Calendar.ptBR.monthSymbols[month - 1].capitalized) de \(year)"
        )

        balance.setup(
            entries: totalEntries,
            exits: totalExits,
            totalBalance: monthBalance,
            filter: movementChipTitle == .entries ? .entries : movementChipTitle == .exits ? .exits : .none
        )
        
        balanceOfMonthValue.text = monthBalance
        
        transactionsChipFilter.configure(titleText: movementChipTitle.localized)
        
        noMovementsAlert.isHidden = !spendings.isEmpty
        
        mainStack.isHidden = false
    }

    @objc func didTapFilterButton(_ sender: UIControl) {
        if sender == accountChipFilter {
            guard let selectedServiceID else { return }
            actionDelegate?.didTapServiceChip(selectedID: selectedServiceID)
        }

        if sender == dateChipFilter {
            guard let selectedMonth, let selectedYear else { return }
            actionDelegate?.didTapDateChip(selectedMonth: selectedMonth, selectedYear: selectedYear)
        }
        
        if sender == transactionsChipFilter {
            actionDelegate?.didTapMovementTypeChip(selected: selectedMovementType)
        }
    }
}

@available(iOS 17.0, *)
#Preview("PFMAccountDetailsView", traits: .portrait) {
    let view = PFMServiceDetailsView().setupView()
    return view
}
