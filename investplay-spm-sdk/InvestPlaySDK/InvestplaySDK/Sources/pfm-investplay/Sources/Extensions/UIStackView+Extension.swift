//
//  UIStackView+Extension.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 16/02/24.
//

import UIKit

// swiftlint:disable all
extension UIStackView {
    func addArrangedSubviews(arrangedSubviews: [UIView]) {
        arrangedSubviews.forEach(addArrangedSubview)
    }
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        arrangedSubviews.forEach(removeArrangedSubview)
    }
    
    func setMargins(
        x: CGFloat = 0,
        y: CGFloat = 0
    ) {
        layoutMargins = UIEdgeInsets(
            x: x,
            y: y
        )
        isLayoutMarginsRelativeArrangement = true
    }
    
    func setMargins(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) {
        layoutMargins = UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
        isLayoutMarginsRelativeArrangement = true
    }
    
    @discardableResult
    func anchorAllToXMargins() -> Self {
        guard isLayoutMarginsRelativeArrangement else {
            arrangedSubviews.forEach({
                $0.anchor(
                    left: leftAnchor,
                    right: rightAnchor
                )
            })
            return self
        }
        
        arrangedSubviews.forEach({
            $0.anchor(
                left: layoutMarginsGuide.leftAnchor,
                right: layoutMarginsGuide.rightAnchor
            )
        })
        
        return self
    }
}
// swiftlint:enable all
