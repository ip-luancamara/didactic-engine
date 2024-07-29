//
//  Transaction+UDS.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 20/06/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk
import UIKit
@_implementationOnly import DesignSystem

extension Transaction_ {
    func toUDS(
        title: String,
        showDivider: Bool = true,
        delegate: UDSSpendingViewModelDelegate? = nil
    ) -> UDSSpendingViewModel {
        UDSSpendingViewModel(
            title: title,
            subtitle: description_,
            description: category?.name ?? I18n.uncategorized.localized,
            icon: ImageAsset.getAsset(
                by: category?.iconName ?? ""
            ).image,
            value: type == .debit ? "-\(amount.formattedAsBRL())" : amount.formattedAsBRL(),
            showDivider: showDivider,
            indicatorColor: UIColor(
                hexString: category?.color ?? UDSColors.grey500.color.hex
            ),
            delegate: delegate
        )
    }
}
