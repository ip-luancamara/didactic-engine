//
//  SpendingCell.swift
//
//
//  Created by Luan Câmara on 13/03/24.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

struct SpendingCaroucelCardViewModel {
    let totalSpendings: String
    let headerSubtitle: String
    let spendings: [PFMSpendingViewModel]
}

class SpendingCell: UICollectionViewCell {
    
    weak var delegate: UDSSpendingViewModelDelegate? {
        didSet {
            spendingView.delegate = delegate
        }
    }

    lazy var spendingView: SpendingView = {
        SpendingView().setupView()
    }()
    
    lazy var emptyAlert: AlertView = {
        let view = AlertView()
        view.configure(
            with: AlertViewModel(
                titleText: I18n.emptySpendingByCategoryTitle.localized,
                descriptionText: I18n.emptySpendingByCategorySubtitle.localized,
                alertStyle: .emptyState
            )
        )
        view.isHidden = true
        return view
    }()

    @discardableResult
    func setup(
        with viewModel: SpendingCaroucelCardViewModel,
        hideValues: Bool,
        delegate: UDSSpendingViewModelDelegate? = nil
    ) -> Self {
        
        self.delegate = delegate

        spendingView.setup(
            totalSpendings: viewModel.totalSpendings,
            headerSubtitle: viewModel.headerSubtitle,
            spendings: viewModel.spendings,
            hideValues: hideValues
        )
        
        emptyAlert.isHidden = !viewModel.spendings.isEmpty

        return self
    }

}

extension SpendingCell: ViewCode {
    func buildViewHierachy() {
        contentView.addSubview(spendingView)
        contentView.addSubview(emptyAlert)
    }

    func addContraints() {
        spendingView.anchorTo(superview: contentView)
        
        emptyAlert.anchor(
            top: spendingView.spendingList.topAnchor,
            left: contentView.leftAnchor,
            right: contentView.rightAnchor
        )
    }
}

extension SpendingCell: UDSSpendingViewModelDelegate {
    func didTapView(sender: DesignSystem.UDSSpending) {
        delegate?.didTapView(sender: sender)
    }
}
