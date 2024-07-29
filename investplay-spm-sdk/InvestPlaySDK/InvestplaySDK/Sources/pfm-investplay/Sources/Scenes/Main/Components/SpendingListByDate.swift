//
//  SpendingListByDate.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 16/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

class SpendingListByDate: UIStackView {

    private func makeSpendingList(
        with spendings: TransactionsPerDateWithIdentifier
    ) -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(y: 16)

        spendings.sorted(by: { $0.key > $1.key }).forEach({
            view.addArrangedSubview(
                makeSpending(
                    in: $0.key,
                    with: $0.value
                )
            )
        })

        return view
    }

    private func makeSpending(
        in day: Date,
        with spendings: [(UDSSpendingViewModel, String)]
    ) -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(y: 16)

        let label = UILabel()
        label.font = FontFamily.OpenSans.regular.small
        label.numberOfLines = 1
        label.text = day.formatted(
            as: "EEEE, dd 'de' MMMM 'de' yyyy"
        ).capitalizedSentence
        view.addArrangedSubview(label)

        spendings.enumerated().forEach({
            let spending = UDSSpending()
            spending.configure(with: $0.element.0)
            spending.accessibilityIdentifier = $0.element.1
            view.addArrangedSubview(spending)
        })

        return view
    }

    func setup(
        with spendings: TransactionsPerDateWithIdentifier
    ) {
        removeAllArrangedSubviews()
        addArrangedSubview(
            makeSpendingList(
                with: spendings
            )
        )
    }
}
