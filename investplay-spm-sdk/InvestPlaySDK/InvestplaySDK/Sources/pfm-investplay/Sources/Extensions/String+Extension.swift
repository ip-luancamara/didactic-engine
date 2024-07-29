//
//  String+Extension.swift
//  InvestPlay
//
//  Created by Luan Câmara on 10/02/24.
//

import Foundation

extension String {
    func toOnlyNumbers() -> Self {
        replacingOccurrences(
            of: "[^0-9]",
            with: "",
            options: .regularExpression
        )
    }

    static let empty: Self = ""

    var capitalizedSentence: String {
        prefix(1).capitalized + dropFirst().lowercased()
    }

    func withHiddenValues() -> Self {
        // swiftlint:disable:next opening_brace
        if #available(iOS 16.0, *) {
            return replacingOccurrences(of: "\u{00A0}", with: " ").replacing(
                #/(R\$) \d{1,3}(?:\.\d{3})*?,\d{2}/#,
                with: I18n.hiddenValue.localized
            )
        } else {
            return self
        }
    }
}
