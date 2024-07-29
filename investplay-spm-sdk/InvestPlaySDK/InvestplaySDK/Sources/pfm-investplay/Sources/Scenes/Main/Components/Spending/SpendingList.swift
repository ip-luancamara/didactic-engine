//
//  SpendingList.swift
//
//
//  Created by Luan Câmara on 12/03/24.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit

class SpendingList: UIStackView, ViewCode {
    
    weak var delegate: UDSSpendingViewModelDelegate?

    func setup(
        with spendingList: [PFMSpendingViewModel],
        hideValues: Bool
    ) {
        removeAllArrangedSubviews()

        addArrangedSubviews(
            arrangedSubviews: spendingList.map({
                let spending = $0.toUDSSpending(hideValues: hideValues, with: self)
                return spending
            })
        )

        if arrangedSubviews.endIndex < 5 {
            addArrangedSubview(.spacer)
            distribution = .fill
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    func buildViewHierachy() { }

    func addContraints() { }

    func addAdditionalConfiguration() {
        axis = .vertical
        distribution = .fillEqually
    }

}

extension SpendingList: UDSSpendingViewModelDelegate {
    func didTapView(sender: DesignSystem.UDSSpending) {
        delegate?.didTapView(sender: sender)
    }
}
