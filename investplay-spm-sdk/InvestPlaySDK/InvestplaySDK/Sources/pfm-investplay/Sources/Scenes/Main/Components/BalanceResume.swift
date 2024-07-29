//
//  BalanceResume.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 16/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

enum BalanceResumeFilterType {
    case entries
    case exits
    case none
}

class BalanceResume: UIStackView, ViewCode {
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [balanceEntriesStack,
                                                  balanceExitsStack])
        view.spacing = 16
        view.distribution = .fillEqually
        return view
    }()

    lazy var balanceEntriesTitle: UILabel = {
        let view = UILabel()
        view.textColor = UDSColors.grey600.color
        view.font = FontFamily.OpenSans.regular.xx_small
        view.text = I18n.entries.localized
        return view
    }()

    lazy var balanceEntriesValue: UILabel = {
        let view = UILabel()
        view.textColor = UDSColors.green500.color
        view.font = FontFamily.OpenSans.regular.small
        return view
    }()

    lazy var balanceEntriesStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            balanceEntriesTitle,
            balanceEntriesValue
        ])
        view.spacing = 4
        view.axis = .vertical
        return view
    }()

    lazy var balanceExitsTitle: UILabel = {
        let view = UILabel()
        view.textColor = UDSColors.grey600.color
        view.font = FontFamily.OpenSans.regular.xx_small
        view.text = I18n.exits.localized
        return view
    }()

    lazy var balanceExitsValue: UILabel = {
        let view = UILabel()
        view.textColor = UDSColors.red500.color
        view.font = FontFamily.OpenSans.regular.small
        return view
    }()

    lazy var balanceExitsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            balanceExitsTitle,
            balanceExitsValue
        ])
        view.spacing = 4
        view.axis = .vertical
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.anchor(height: 1)
        view.backgroundColor = UDSColors.grey200.color
        return view
    }()

    @discardableResult
    func setup(
        entries: String,
        exits: String,
        totalBalance: String,
        filter: BalanceResumeFilterType = .none
    ) -> Self {
        balanceEntriesValue.text = entries
        balanceExitsValue.text = exits
        
        if filter == .none {
            balanceEntriesValue.textColor = UDSColors.green500.color
            balanceExitsValue.textColor = UDSColors.red500.color
        } else {
            balanceEntriesValue.textColor = filter == .entries ? UDSColors.green500.color : UDSColors.grey500.color
            balanceExitsValue.textColor = filter == .exits ? UDSColors.red500.color : UDSColors.grey500.color
        }
        
        return setupView()
    }

    func buildViewHierachy() {
        addArrangedSubviews(arrangedSubviews: [
            mainStack,
            line
        ])
    }

    func addContraints() {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(y: 12)
    }

    func addAdditionalConfiguration() {
        axis = .vertical
        spacing = 12
    }
}
