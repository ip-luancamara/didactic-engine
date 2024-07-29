//
//  UIView+AutoLayout.swift
//  InvestPlay
//
//  Created by Luan Câmara on 09/02/24.
//

import UIKit

extension UIView {

    /// Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor
    ///   - left: current view's left anchor will be anchored into the specified anchor
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor
    ///   - right: current view's right anchor will be anchored into the specified anchor
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    ///   - widthConstant: current view's width
    ///   - heightConstant: current view's height
    /// - Returns: array of newly added constraints (if applicable).
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingRight: CGFloat = 0,
        width: CGFloat = 0,
        height: CGFloat = 0
    ) -> Self {

        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top {
            anchors.append(
                topAnchor.constraint(
                    equalTo: top,
                    constant: paddingTop
                )
            )
        }

        if let left {
            anchors.append(
                leftAnchor.constraint(
                    equalTo: left,
                    constant: paddingLeft
                )
            )
        }

        if let bottom {
            anchors.append(
                bottomAnchor.constraint(
                    equalTo: bottom,
                    constant: -paddingBottom
                )
            )
        }

        if let right {
            anchors.append(
                rightAnchor.constraint(
                    equalTo: right,
                    constant: -paddingRight
                )
            )
        }

        if width > 0 {
            anchors.append(
                widthAnchor.constraint(
                    equalToConstant: width
                )
            )
        }

        if height > 0 {
            anchors.append(
                heightAnchor.constraint(
                    equalToConstant: height
                )
            )
        }

        NSLayoutConstraint.activate(anchors)

        return self
    }

    enum Anchor {
        case `default`
        case safeArea
        case layoutMargins
    }

    func anchorTo(superview: UIView, margin: CGFloat = 0, anchorTo: Anchor = .default) {
        switch anchorTo {
        case .default:
            anchor(
                top: superview.topAnchor,
                left: superview.leftAnchor,
                bottom: superview.bottomAnchor,
                right: superview.rightAnchor,
                paddingTop: margin,
                paddingLeft: margin,
                paddingBottom: margin,
                paddingRight: margin
            )
        case .safeArea:
            anchor(
                top: superview.safeAreaLayoutGuide.topAnchor,
                left: superview.safeAreaLayoutGuide.leftAnchor,
                bottom: superview.safeAreaLayoutGuide.bottomAnchor,
                right: superview.safeAreaLayoutGuide.rightAnchor,
                paddingTop: margin,
                paddingLeft: margin,
                paddingBottom: margin,
                paddingRight: margin
            )
        case .layoutMargins:
            anchor(
                top: superview.layoutMarginsGuide.topAnchor,
                left: superview.layoutMarginsGuide.leftAnchor,
                bottom: superview.layoutMarginsGuide.bottomAnchor,
                right: superview.layoutMarginsGuide.rightAnchor,
                paddingTop: margin,
                paddingLeft: margin,
                paddingBottom: margin,
                paddingRight: margin
            )
        }
    }

    func anchorXTo(
        margin: Anchor = .default,
        in superview: UIView,
        with padding: CGFloat = 0
    ) {
        switch margin {
        case .default:
            anchor(
                left: superview.leftAnchor,
                right: superview.rightAnchor,
                paddingLeft: padding,
                paddingRight: padding
            )
        case .safeArea:
            anchor(
                left: superview.safeAreaLayoutGuide.leftAnchor,
                right: superview.safeAreaLayoutGuide.rightAnchor,
                paddingLeft: padding,
                paddingRight: padding
            )
        case .layoutMargins:
            anchor(
                left: superview.layoutMarginsGuide.leftAnchor,
                right: superview.layoutMarginsGuide.rightAnchor,
                paddingLeft: padding,
                paddingRight: padding
            )
        }
    }

    func anchorYTo(
        margin: Anchor = .default,
        in superview: UIView,
        with padding: CGFloat = 0
    ) {
        switch margin {
        case .default:
            anchor(
                top: superview.topAnchor,
                bottom: superview.bottomAnchor,
                paddingTop: padding,
                paddingBottom: padding
            )
        case .safeArea:
            anchor(
                top: superview.safeAreaLayoutGuide.topAnchor,
                bottom: superview.safeAreaLayoutGuide.bottomAnchor,
                paddingTop: padding,
                paddingBottom: padding
            )
        case .layoutMargins:
            anchor(
                top: superview.layoutMarginsGuide.topAnchor,
                bottom: superview.layoutMarginsGuide.bottomAnchor,
                paddingTop: padding,
                paddingBottom: padding
            )
        }
    }

    /// Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    func anchorCenterXToSuperview(
        constant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(
                equalTo: anchor,
                constant: constant
            ).isActive = true
        }
    }

    /// Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    func anchorCenterYToSuperview(
        constant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(
                equalTo: anchor,
                constant: constant
            ).isActive = true
        }
    }

    /// Anchor center X and Y into current view's superview
    func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }

}
