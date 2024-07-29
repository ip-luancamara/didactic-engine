//
//  UIEdgeInsets+Extension.swift
//  
//
//  Created by Luan Fabiano on 01/03/23.
//

import Foundation
import UIKit

// swiftlint:disable all
extension UIEdgeInsets {
    init(
        all size: CGFloat
    ) {
        self.init(
            top: size,
            left: size,
            bottom: size,
            right: size
        )
    }
    
    init(
        x: CGFloat = 0,
        y: CGFloat = 0
    ) {
        self.init(
            top: y,
            left: x,
            bottom: y,
            right: x
        )
    }
    
    static func allEdgesEqual(
        size: CGFloat
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: size,
            left: size,
            bottom: size,
            right: size
        )
    }
}
// swiftlint:enable all
