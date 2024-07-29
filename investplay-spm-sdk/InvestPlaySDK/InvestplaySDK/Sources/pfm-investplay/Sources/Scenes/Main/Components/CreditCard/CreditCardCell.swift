//
//  CreditCardCell.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 10/06/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

class CreditCardView: UIView {
    
    lazy var creditCardView: UDSBalanceCreditCard = {
        UDSBalanceCreditCard()
    }()
    
    lazy var bankImage: UDSAvatar = {
        let view = UDSAvatar(dimension: .small)
        return view
    }()

    @discardableResult
    func setup(
        with creditCard: CreditCard,
        hideValues: Bool
    ) -> Self {
        creditCardView.configure(with: creditCard.toUDS())
        creditCardView.isHiddenValues = hideValues
        bankImage.configure(with: UDSAvatarModel(urlImage: URL(string: creditCard.bankImage)))
        return self
    }
    
}

extension CreditCardView: ViewCode {
    func buildViewHierachy() {
        addSubview(creditCardView)
        addSubview(bankImage)
    }

    func addContraints() {
        creditCardView.anchorTo(superview: self)
        
        bankImage.anchor(
            top: topAnchor,
            right: rightAnchor,
            paddingTop: 96,
            paddingRight: 16
        )
    }
    
    func addAdditionalConfiguration() {
        creditCardView.isUserInteractionEnabled = false
    }
}

class CreditCardCell: UICollectionViewCell {
    
    lazy var container: UDSContainerView = {
        UDSContainerView(style: .filled, containerView: creditCardView)
    }()

    lazy var creditCardView: CreditCardView = {
        CreditCardView().setupView()
    }()
    
    @discardableResult
    func setup(
        with creditCard: CreditCard,
        hideValues: Bool
    ) -> Self {
        creditCardView.setup(
            with: creditCard,
            hideValues: hideValues
        )
        return self
    }
}

extension CreditCardCell: ViewCode {
    func buildViewHierachy() {
        contentView.addSubview(container)
    }

    func addContraints() {
        container.anchorTo(superview: contentView)
    }
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(
            width: layoutAttributes.frame.width,
            height: 0
        )
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
}
