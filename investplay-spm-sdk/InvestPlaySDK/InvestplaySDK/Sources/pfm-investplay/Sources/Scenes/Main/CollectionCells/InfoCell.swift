//
//  InfoCell.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 16/02/24.
//

import UIKit
@_implementationOnly import DesignSystem

class InfoCell: UICollectionViewCell, ViewCode {

    lazy var card: UDSCardText = {
        let card = UDSCardText(style: .primary)
        return card
    }()

    @discardableResult
    func setup(
        title: String? = nil,
        description: String = .empty,
        iconName: String = .empty
    ) -> Self {
        if title == nil, description.isEmpty, iconName.isEmpty {
            card.showSkeleton()
            return self
        }
        
        card.configure(
            with: UDSCardTextViewModel(
                titleDescription: title,
                subtitleDescription: description,
                icon: ImageAsset.getAsset(by: iconName)
            )
        )
        
        if let title {
            card.accessibilityValue = "\(title). \(description)".replacingOccurrences(of: I18n.hiddenValue.localized, with: "Saldo oculto pelo usuário")
        } else {
            card.accessibilityValue = "\(description)".replacingOccurrences(of: I18n.hiddenValue.localized, with: "Saldo oculto pelo usuário")
        }
        
        
        
        setNeedsLayout()
        layoutIfNeeded()
        card.hideSkeleton()
        return self
    }

    func buildViewHierachy() {
        addSubview(card)
    }

    func addContraints() {
        card.anchorTo(superview: self)
    }

    func addAdditionalConfiguration() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        contentMode = .center
    }

}
