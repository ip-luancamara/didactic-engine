//
//  HeaderCell.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 16/02/24.
//

import UIKit
@_implementationOnly import DesignSystem

class HeaderCell: UICollectionReusableView, ViewCode {

    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel])
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 20, y: 0)
        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = I18n.myExpenses.localized
        view.font = FontFamily.OpenSans.bold.huge
        view.textColor = UDSColors.primary500.color
        return view
    }()

    func buildViewHierachy() {
        addSubview(mainStack)
    }

    func addContraints() {
        mainStack.anchorTo(superview: self)
    }
}
