//
//  PFMCategoryTransactionsView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 26/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

class PFMCategoryTransactionsView: UIScrollView, ViewCode {
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            totalSpentOnCategoryStack,
            totalSpentOnCategoryMonthLabel,
            spendingList
        ])
        view.axis = .vertical
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16, y: 24)
        view.spacing = 12
        view.setCustomSpacing(40, after: totalSpentOnCategoryMonthLabel)
        return view
    }()
    
    lazy var totalSpentOnCategoryLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.numberOfLines = 1
        view.text = I18n.totalSpentOnCategory.localized
        return view
    }()

    lazy var totalSpentOnCategoryValue: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.numberOfLines = 1
        return view
    }()
    
    lazy var totalSpentOnCategoryMonthLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.x_small
        view.numberOfLines = 1
        view.textColor = UDSColors.grey600.color
        return view
    }()

    lazy var totalSpentOnCategoryStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            totalSpentOnCategoryLabel,
            .spacer,
            totalSpentOnCategoryValue
        ])
        view.anchor(height: 20)
        return view
    }()

    lazy var spendingList: SpendingListByDate = {
        SpendingListByDate()
    }()

    func buildViewHierachy() {
        addSubview(mainStack)
    }
    
    func setup(
        filterDate: String,
        totalExpenses: String,
        expenses: TransactionsPerDateWithIdentifier
    ) {
        spendingList.setup(with: expenses)
        totalSpentOnCategoryValue.text = totalExpenses
        totalSpentOnCategoryMonthLabel.text = filterDate
    }

    func addContraints() {
        mainStack.arrangedSubviews.forEach({
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
}

@available(iOS 17.0, *)
#Preview("PFMCategoryTransactionsView", traits: .portrait) {
    let view = PFMCategoryTransactionsView().setupView()
    return view
}
