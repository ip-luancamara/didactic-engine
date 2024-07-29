//
//  HeaderWithBalance.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 20/02/24.
//  Copyright © 2024 InvestPlay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

class BalanceHeaderView: UIStackView, ViewCode, Loadable {
    var isLoading: Bool = false {
        didSet {
            guard isLoading else {
                hideLoading()
                return
            }
            
            showLoading()
        }
    }

    var balance: Double = 0 {
        didSet {
            subtitleBalanceLabel.text = balance.formattedAsBRL()
        }
    }

    var hideValues = false {
        didSet {
            subtitleBalanceLabel.text = hideValues ? I18n.hiddenValue.localized : balance.formattedAsBRL()
            subtitleBalanceLabel.accessibilityLabel = hideValues ? "Saldo oculto pelo usuário" : balance.formattedAsBRL()
        }
    }

    lazy var heading: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(customTopAnchor: 24, labelStyle: .small)
        return view
    }()

    lazy var subtitleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [subtitleLabel, subtitleBalanceLabel])
        view.distribution = .equalSpacing
        view.isSkeletonable = true
        return view
    }()

    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textColor = UDSColors.grey900.color
        view.isSkeletonable = true
        return view
    }()

    lazy var subtitleBalanceLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textColor = UDSColors.grey900.color
        view.isSkeletonable = true
        return view
    }()

    @discardableResult
    func setup(
        title: I18n,
        subtitle: I18n,
        balance: Double
    ) -> Self {
        heading.configure(headingText: title.localized, headingColor: .black)
        subtitleLabel.text = subtitle.localized
        self.balance = balance
        return self
    }

    func buildViewHierachy() {
        addArrangedSubviews(arrangedSubviews: [heading, subtitleStack])
    }

    func addContraints() { }

    func addAdditionalConfiguration() {
        axis = .vertical
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(x: 16)
        spacing = 12
        subtitleStack.isSkeletonable = true
    }
    
    func showLoading() {
        heading.showSkeleton()
        subtitleStack.showSkeleton()
    }
    
    func hideLoading() {
        heading.hideSkeleton()
        subtitleStack.hideSkeleton()
    }
}
