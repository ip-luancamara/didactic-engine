//
//  PFMExpensesView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 06/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

protocol PFMExpensesViewDelegate: AnyObject {
    func didTapFilterButton()
}

class PFMExpensesView: UIScrollView, ViewCode {
    
    weak var actionDelegate: PFMExpensesViewDelegate?
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            chipStack,
            balanceOfMonthStack,
            spendingChartList
        ])
        view.axis = .vertical
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16, y: 16)
        view.spacing = 16
        view.setCustomSpacing(20, after: balanceOfMonthStack)
        return view
    }()

    lazy var dateChipFilter: UDSChipMultipleSelection = {
        let view = UDSChipMultipleSelection(titleText: .empty)
        view.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        return view
    }()

    lazy var chipStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [chipStackPrimary])
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()

    lazy var chipStackPrimary: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateChipFilter])
        view.spacing = 16
        return view
    }()
    
    lazy var balanceOfMonthLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.x_small
        view.numberOfLines = 1
        view.text = I18n.totalOnPeriod.localized
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
            .spacer,
            balanceOfMonthValue
        ])
        view.anchor(height: 20)
        return view
    }()
    
    lazy var spendingChartList: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()

    func buildViewHierachy() {
        addSubview(mainStack)
    }
    
    func setup(
        filterDate: String,
        totalSpent: String,
        spendingsCategories: IdentifiableCategories
    ) {
        balanceOfMonthValue.text = totalSpent
        
        dateChipFilter.configure(titleText: filterDate.capitalizedSentence)
        
        makeSpendingChartList(
            with: spendingsCategories
        )
    }
    
    @objc func didTapFilter() {
        actionDelegate?.didTapFilterButton()
    }

    func addContraints() {
        [
            chipStack,
            balanceOfMonthStack,
            spendingChartList
        ].forEach({
            $0.anchor(
                left: mainStack.layoutMarginsGuide.leftAnchor,
                right: mainStack.layoutMarginsGuide.rightAnchor
            )
        })

        mainStack.anchor(
            top: contentLayoutGuide.topAnchor,
            left: safeAreaLayoutGuide.leftAnchor,
            bottom: contentLayoutGuide.bottomAnchor,
            right: safeAreaLayoutGuide.rightAnchor
        )
    }

    func addAdditionalConfiguration() {
        showsVerticalScrollIndicator = false
    }
    
    private func makeSpendingChartList(
        with models: IdentifiableCategories
    ) {
        spendingChartList.removeAllArrangedSubviews()
        models.map(
            makeSpendingChart
        ).forEach(
            spendingChartList.addArrangedSubview
        )
    }
    
    private func makeSpendingChart(
        with model: UDSSpendingChartModel,
        id: String
    ) -> UDSSpendingChart {
        let view = UDSSpendingChart()
        
        view.configure(
            with: model
        )
        
        view.accessibilityIdentifier = id
        
        view.anchor(height: 84)
        return view
    }
}

@available(iOS 17.0, *)
#Preview("PFMExpensesView", traits: .portrait) {
    let view = PFMExpensesView().setupView()
    return view
}
