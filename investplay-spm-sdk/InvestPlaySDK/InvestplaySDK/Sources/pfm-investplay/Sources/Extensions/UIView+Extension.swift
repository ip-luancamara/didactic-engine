//
//  UIView+Extension.swift
//  
//
//  Created by Luan Camara on 21/10/22.
//

import Foundation
import UIKit

extension UIView {

    func removeAllConstraints() {
        // swiftlint:disable:next identifier_name
        var _superview = superview

        while let superview = _superview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }

        removeConstraints(constraints)
    }

    func addSubviews(subviews: [UIView]) {
        subviews.forEach(addSubview)
    }

    func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }

    static var spacer: UIView {
        let view = UIView()
        return view
    }
}

extension UIView {

    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        var subviews: [T] = []
        
        if let stack = parenView as? UIStackView {
            stack.arrangedSubviews.forEach {
                var result = getAllSkeletonableSubviews(from: $0) as [T]
                if let view = $0 as? T { result.append(view) }
                subviews.append(contentsOf: result)
            }
        }
        
        parenView.subviews.forEach {
            var result = getAllSkeletonableSubviews(from: $0) as [T]
            if let view = $0 as? T { result.append(view) }
            subviews.append(contentsOf: result)
        }
        
        return subviews
    }

    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }
    
    class func getAllSkeletonableSubviews<T: UIView>(from parenView: UIView) -> [T] {
        var subviews: [T] = []
        
        if let stack = parenView as? UIStackView {
            stack.arrangedSubviews.filter({ $0.isSkeletonable }).forEach {
                var result = getAllSkeletonableSubviews(from: $0) as [T]
                if let view = $0 as? T { result.append(view) }
                subviews.append(contentsOf: result)
            }
        }
        
        parenView.subviews.filter({ $0.isSkeletonable }).forEach {
            var result = getAllSkeletonableSubviews(from: $0) as [T]
            if let view = $0 as? T { result.append(view) }
            subviews.append(contentsOf: result)
        }
        
        return subviews
    }

    func getAllSkeletonableSubviews<T: UIView>() -> [T] { return UIView.getAllSkeletonableSubviews(from: self) as [T] }
    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get<T: UIView>(all type: T.Type) -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get(all types: [UIView.Type]) -> [UIView] { return UIView.getAllSubviews(from: self, types: types) }
}
