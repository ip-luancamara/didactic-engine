//
//  UILabel+I18n.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 10/06/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    @discardableResult
    func setText(to newText: I18n) -> Self {
        text = newText.localized
        return self
    }
}
