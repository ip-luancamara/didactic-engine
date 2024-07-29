//
//  SpendingView.swift
//
//
//  Created by Luan Câmara on 13/03/24.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit

class SpendingView: UIStackView {
    
    lazy var theme: Theme = Theme()
    
    weak var delegate: UDSSpendingViewModelDelegate?

    lazy var header: BalanceCompositionHeader = {
        BalanceCompositionHeader().setupView()
    }()

    lazy var spendingList: SpendingList = {
        SpendingList().setupView()
    }()

    @discardableResult
    func setup(
        totalSpendings: String,
        headerSubtitle: String,
        spendings: [PFMSpendingViewModel],
        hideValues: Bool
    ) -> Self {
        header.setup(
            totalValue: totalSpendings,
            subtitle: headerSubtitle,
            chartData: spendings.map({ DonutChartDataEntry(value: $0.percentage, color: $0.indicatorColor) }),
            hideValues: hideValues
        )

        spendingList.setup(
            with: spendings,
            hideValues: hideValues
        )
        
        spendingList.delegate = self

        return self
    }
}

extension SpendingView: ViewCode {
    func buildViewHierachy() {
        addArrangedSubviews(arrangedSubviews: [
            header,
            spendingList
        ])
    }

    func addContraints() {
        layoutMargins = UIEdgeInsets(x: theme.spacing.spacing16, y: 0)
        arrangedSubviews.forEach({ $0.anchorXTo(margin: .layoutMargins, in: self) })
    }

    func addAdditionalConfiguration() {
        spacing = 12
        axis = .vertical
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
    }
}

extension SpendingView: UDSSpendingViewModelDelegate {
    func didTapView(sender: DesignSystem.UDSSpending) {
        delegate?.didTapView(sender: sender)
    }
}
