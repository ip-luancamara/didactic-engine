//
//  ConnectCreditCardCell.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 10/06/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

class ConnectCreditCardCell: UICollectionViewCell {
    
    lazy var container: UDSContainerView = {
        UDSContainerView(style: .filled, containerView: mainView)
    }()
    
    lazy var mainView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            creditCardHeader,
            content
        ])
        view.axis = .vertical
        return view
    }()
    
    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    lazy var content: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            titleStack,
            divider,
            actionStack
        ])
        view.axis = .vertical
        view.layoutMargins = UIEdgeInsets(all: 16)
        view.isLayoutMarginsRelativeArrangement = true
        view.setCustomSpacing(16, after: titleStack)
        view.setCustomSpacing(16, after: divider)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.medium.large
        view.numberOfLines = 1
        view.textColor = UDSColors.grey600.color
        view.text = "Organização financeira"
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.xx_small
        view.textColor = UDSColors.grey600.color
        view.text = "Traga seus dados e tenha todos os seus cartões de crédito dentro do Gerenciador Financeiro."
        view.numberOfLines = 0
        return view
    }()
    
    lazy var actionStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            actionLabel,
            .spacer,
            actionImage
        ])
        view.anchor(height: 44)
        view.alignment = .center
        return view
    }()

    lazy var actionLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.semiBold.small
        view.numberOfLines = 1
        view.textColor = UDSColors.primary300.color
        view.text = "Trazer meus dados"
        return view
    }()
    
    lazy var actionImage: UIImageView = {
        let view = UIImageView(image: UDSAssets.chevronRight.image)
        view.tintColor = UDSColors.primary300.color
        view.contentMode = .scaleAspectFit
        view.anchor(width: 24, height: 24)
        return view
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.anchor(height: 1)
        view.backgroundColor = UDSColors.grey200.color
        return view
    }()
    
    lazy var creditCardHeader: UDSCreditCardHeaderView = {
        let view = UDSCreditCardHeaderView()
        view.configure(
            with: UDSCreditCardHeaderModel(
                logo: UDSAssets.udsOpenFinance.image,
                logoTintColor: .white,
                name: "Cartões conectados",
                nameColor: .white,
                dividerColor: .white,
                backgroundImage: UDSAssets.udsVisaProductCurves.image,
                backgroundColor: UDSColors.blue600.color
            )
        )
        return view
    }()

}

extension ConnectCreditCardCell: ViewCode {
    func buildViewHierachy() {
        addSubview(container)
    }

    func addContraints() {
        container.anchorTo(superview: self)
    }
    
    func addAdditionalConfiguration() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
