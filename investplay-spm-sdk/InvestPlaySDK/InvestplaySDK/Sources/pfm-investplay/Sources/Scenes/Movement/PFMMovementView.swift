//
//  PFMMovementView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 26/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

enum PFMMovementViewType: Int {
    case myExpenses
    case allTransactions
}

enum PFMMovementType {
    case entries
    case exits
}

protocol PFMMovementViewDelegate: AnyObject {
    func didTapDateChip()
    func didTapMovementTypeChip()
    func didSelect(tab: PFMMovementViewType)
}

class PFMMovementView: UIScrollView, ViewCode {
    
    var type: PFMMovementViewType = .myExpenses {
        didSet {
            balanceOfMonthLabel.text = isAllTransactions ? I18n.monthBalance.localized : I18n.myExpenses.localized
            balance.isHidden = !isAllTransactions
            chipStackSecondary.isHidden = !isAllTransactions
            myExpensesCalcInfo.isHidden = isAllTransactions
        }
    }

    var isAllTransactions: Bool {
        type == .allTransactions
    }
    
    weak var actionDelegate: PFMMovementViewDelegate?
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            chipStack,
            balance,
            balanceOfMonthStack,
            myExpensesCalcInfo,
            updatedAtCard,
            spendingList,
            .spacer
        ])
        view.axis = .vertical
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16, y: 16)
        view.spacing = 16
        view.setCustomSpacing(0, after: balance)
        view.setCustomSpacing(20, after: myExpensesCalcInfo)
        view.setCustomSpacing(8, after: balanceOfMonthStack)
        return view
    }()
    
    lazy var tabBarGroup: UDSTabBarGroup = {
        let view = UDSTabBarGroup()
        view.configure(
            items: [
                UDSTabBarGroupModel(
                    title: I18n.myExpenses.localized
                ),
                UDSTabBarGroupModel(
                    title: I18n.allTransactions.localized
                )
            ]
        )
        view.addTargets(self, action: #selector(didTapTab))
        return view
    }()

    lazy var dateChipFilter: UDSChipMultipleSelection = {
        let view = UDSChipMultipleSelection(titleText: .empty)
        view.addTarget(
            self,
            action: #selector(
                didTapFilterButton
            ),
            for: .touchUpInside
        )
        return view
    }()

    lazy var movementTypeFilterChip: UDSChipMultipleSelection = {
        let view = UDSChipMultipleSelection(titleText: I18n.movimentationType.localized)
        view.addTarget(
            self,
            action: #selector(
                didTapFilterButton
            ),
            for: .touchUpInside
        )
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

    lazy var chipStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [chipStackPrimary, chipStackSecondary])
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()

    lazy var chipStackPrimary: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateChipFilter])
        view.spacing = 16
        return view
    }()

    lazy var chipStackSecondary: UIStackView = {
        let view = UIStackView(arrangedSubviews: [movementTypeFilterChip])
        view.spacing = 16
        return view
    }()

    lazy var balance: BalanceResume = {
        let view = BalanceResume()
        return view
    }()
    
    lazy var myExpensesCalcInfo: UILabel = {
        let view = ParagraphLabelFormatterBuilder()
            .style(.x_small)
            .textColor(.contentSecondary)
            .numberOfLines(numberOfLines: .zero)
            .build()
        view.text = "O cálculo de gastos não considera entrada de valores, transações entre as suas contas, pagamentos de faturas e outras transações sinalizadas."
        view.isHidden = isAllTransactions
        return view
    }()
    
    lazy var balanceOfMonthLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.numberOfLines = 1
        return view
    }()

    lazy var balanceOfMonthValue: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.numberOfLines = 1
        return view
    }()

    lazy var balanceOfMonthStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            balanceOfMonthLabel,
            .spacer,
            balanceOfMonthValue
        ])
        view.anchor(height: 20)
        return view
    }()

    lazy var updatedAtCard: UDSCardText = {
        let view = UDSCardText()
        view.anchor(
            height: 56
        )
        return view
    }()

    lazy var spendingList: SpendingListByDate = {
        SpendingListByDate()
    }()

    func buildViewHierachy() {
        addSubview(tabBarGroup)
        addSubview(mainStack)
        mainStack.addSubview(noMovementsAlert)
    }
    
    func setup(
        filterDate: String,
        totalExpenses: String,
        updatedAt: String,
        expenses: TransactionsPerDateWithIdentifier
    ) {
        type = .myExpenses
        
        spendingList.setup(with: expenses)
        
        updatedAtCard.configure(
            with: UDSCardTextViewModel(
                subtitleDescription: updatedAt,
                icon: UDSAssets.udsOpen,
                style: .secondary
            )
        )
        
        balanceOfMonthValue.text = totalExpenses
        
        dateChipFilter.configure(titleText: filterDate)
        
        movementTypeFilterChip.configure(titleText: I18n.movimentationType.localized)
        
        noMovementsAlert.isHidden = !expenses.isEmpty
    }
    
    func setup(
        filterDate: String,
        totalExits: String,
        totalEntries: String,
        total: String,
        updatedAt: String,
        movementTypeFilter: String,
        balanceFilter: BalanceResumeFilterType,
        expenses: TransactionsPerDateWithIdentifier
    ) {
        type = .allTransactions
        
        spendingList.setup(with: expenses)
        
        updatedAtCard.configure(
            with: UDSCardTextViewModel(
                subtitleDescription: updatedAt,
                icon: UDSAssets.udsOpen,
                style: .secondary
            )
        )
        
        balance.setup(
            entries: totalEntries,
            exits: totalExits,
            totalBalance: total,
            filter: balanceFilter
        )
        
        balanceOfMonthValue.text = total
        
        dateChipFilter.configure(titleText: filterDate)
        movementTypeFilterChip.configure(titleText: movementTypeFilter)
    }

    func addContraints() {
        tabBarGroup.anchor(
            top: contentLayoutGuide.topAnchor,
            left: safeAreaLayoutGuide.leftAnchor,
            right: safeAreaLayoutGuide.rightAnchor
        )
        
        [
            chipStack,
            balance,
            balanceOfMonthStack,
            myExpensesCalcInfo,
            updatedAtCard,
            spendingList
        ].forEach({
            $0.anchor(
                left: mainStack.layoutMarginsGuide.leftAnchor,
                right: mainStack.layoutMarginsGuide.rightAnchor
            )
        })

        mainStack.anchor(
            top: tabBarGroup.bottomAnchor,
            left: safeAreaLayoutGuide.leftAnchor,
            bottom: contentLayoutGuide.bottomAnchor,
            right: safeAreaLayoutGuide.rightAnchor
        )
        
        noMovementsAlert.anchor(
            top: updatedAtCard.bottomAnchor,
            left: mainStack.leftAnchor,
            right: mainStack.rightAnchor,
            paddingTop: 32
        )
    }

    func addAdditionalConfiguration() {
        showsVerticalScrollIndicator = false
    }

    @objc func didTapFilterButton(_ sender: UIControl) {
        if sender == dateChipFilter {
            actionDelegate?.didTapDateChip()
        }
        
        if sender == movementTypeFilterChip {
            actionDelegate?.didTapMovementTypeChip()
        }
    }
    
    @objc func didTapTab(_ sender: UIButton) {
        let tab: PFMMovementViewType = sender.titleLabel?.text == I18n.myExpenses.localized ? .myExpenses : .allTransactions
        
        guard tab != type else { return }
        
        DispatchQueue.global().async { [weak self] in
            self?.actionDelegate?.didSelect(tab: tab)
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.tabBarGroup.selectTab(at: tab.rawValue)
            }
        }
        
    }
}

@available(iOS 17.0, *)
#Preview("PFMMovementView", traits: .portrait) {
    let view = PFMMovementView().setupView()
    return view
}
