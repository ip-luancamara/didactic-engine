//
//  DockerView+Extension.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 29/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@_implementationOnly import DesignSystem

extension DockerView {
    func hideDivider() -> Self {
        subviews.first(where: { $0 is DividerComponentView })?.isHidden = true
        return self
    }
}
