//
//  BalanceCompositionHeader.swift
//
//
//  Created by Luan Câmara on 12/03/24.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit
import SwiftUI

class BalanceCompositionHeader: UIStackView, ViewCode {

    lazy var totalLabel: UILabel = {
      ParagraphLabelFormatterBuilder()
            .style(.small)
            .textColor(.contentSecondary)
            .build()
    }()

    lazy var valueLabel: UILabel = {
        LabelComponentBuilder()
            .style(.numeralLarge)
            .textColor(.black)
            .build()
    }()

    lazy var dateLabel: UILabel = {
        ParagraphLabelFormatterBuilder()
            .style(.small)
            .textColor(.contentSecondary)
            .build()
    }()

    lazy var chart: DonutChartView = {
        DonutChartView(lineWidth: 12)
    }()

    lazy var infoStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            totalLabel,
            valueLabel,
            dateLabel
        ])
        view.distribution = .equalSpacing
        view.alignment = .leading
        view.axis = .vertical
        return view
    }()

    func buildViewHierachy() {
        addArrangedSubviews(arrangedSubviews: [infoStack, chart])
    }

    func addContraints() {
        chart.anchor(width: 88, height: 88)
    }
    
    func addAdditionalConfiguration() {
        totalLabel.setText(to: .total)
    }

    @discardableResult
    func setup(
        totalValue: String,
        subtitle: String,
        chartData: [DonutChartDataEntry],
        hideValues: Bool
    ) -> Self {
        chart.setup(
            data: chartData,
            type: .categoryHeader
        )

        chart.lineCap = .butt
        chart.lineSpace = chartData.isEmpty ? .joined : .spaced

        dateLabel.text = subtitle
        valueLabel.text = hideValues ? I18n.hiddenValue.localized : totalValue

        return self
    }
}

@available(iOS 17.0, *)
#Preview(
    traits: .fixedLayout(
        width: 500,
        height: 100
    ),
    .sizeThatFitsLayout
) {
    BalanceCompositionHeader()
        .setupView()
        .setup(
            totalValue: "R$ 500",
            subtitle: "Teste",
            chartData: [],
            hideValues: false
        )
        .anchor(
            width: 350
        )
}
