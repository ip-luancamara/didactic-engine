//
//  BarChartView.swift
//
//
//  Created by Luan Câmara on 14/03/24.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

struct BarChartViewData {
    let value: Double
    let title: String
    let subtitle: String
}

class BarChartView: UIStackView {

    let maxBarHeight: CGFloat = 160

    let theme = Theme()

    weak var delegate: ChartsCarroucelDelegate?

    lazy var chartView: UIStackView = {
        let view = UIStackView()
        view.setMargins(x: theme.spacing.spacing32)
        view.distribution = .equalSpacing
        view.alignment = .trailing
        return view
    }()

    lazy var titleStack: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        return view
    }()

    lazy var grid: UIStackView = {
        let config = DashedView.Configuration(
            color: theme.colors.grey100,
            dashLength: theme.size.size12,
            dashGap: theme.spacing.xx_small
        )

        let view = UIStackView(arrangedSubviews: [])

        for _ in 0...8 {
            view.addArrangedSubview(
                DashedView().setup(
                    with: config
                )
            )
        }

        view.axis = .vertical
        view.distribution = .equalCentering
        return view
    }()

    lazy var baseLine: DashedView = {
        let baseLineConfig = DashedView.Configuration(
            color: theme.colors.black,
            dashLength: theme.size.size12,
            dashGap: 0
        )

        return DashedView().setup(with: baseLineConfig)

    }()

    var data: [BarChartViewData] = [] {
        didSet {
            chartView.removeAllArrangedSubviews()
            titleStack.removeAllArrangedSubviews()

            guard let maxValue = data.map({ $0.value }).max() else { return }

            let bars = data.map({ createBar(for: $0, maxValue: maxValue) })
            let labels = data.map { createLabel(for: $0) }

            chartView.addArrangedSubviews(arrangedSubviews: bars)
            titleStack.addArrangedSubviews(arrangedSubviews: labels)
            layoutIfNeeded()
        }
    }

    @discardableResult
    func setup(
        with data: [BarChartViewData],
        delegate: ChartsCarroucelDelegate? = nil
    ) -> Self {
        self.data = data
        self.delegate = delegate
        return self
    }

    private func createBar(
        for data: BarChartViewData,
        maxValue: Double
    ) -> UIView {
        let view = UIView()
        view.clipsToBounds = true

        view.backgroundColor = theme.colors.grey700
        view.layer.cornerRadius = theme.borderStyle.radius.sm
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.anchor(
            width: 30,
            height: CGFloat(
                data.value/maxValue
            ) * maxBarHeight
        )

        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(
                    didTapBar
                )
            )
        )

        view.isUserInteractionEnabled = true

        return view
    }

    private func createLabel(
        for data: BarChartViewData
    ) -> UIView {
        let view = UIStackView()

        let subtitleLabel = LabelComponentBuilder()
          .style(LabelComponentStyle.x_small)
          .textColor(ColorScheme.grey800)
          .textAlignment(.center)
          .build()

        let valueLabel = UDSValue()

        valueLabel.configure(
            model: UDSValueViewModel(
                text: data.title,
                style: .neutralXSmall
            )
        )

        valueLabel.textAlignment = .center

        subtitleLabel.text = data.subtitle

        view.addArrangedSubviews(
            arrangedSubviews: [
                valueLabel,
                subtitleLabel
            ]
        )

        view.anchor(width: 90)

        view.axis = .vertical
        view.spacing = theme.spacing.spacing4

        return view
    }

    @objc func didTapBar(_ action: UITapGestureRecognizer) {
        guard let view = action.view, let index = chartView.arrangedSubviews.firstIndex(
            of: view
        ) else {
            return
        }

        delegate?.didTapChart(
            type: .bars(
                index: index
            )
        )
    }

}

extension BarChartView: ViewCode {
    func buildViewHierachy() {
        addArrangedSubview(chartView)
        addArrangedSubview(baseLine)
        addArrangedSubview(titleStack)
        chartView.addSubview(grid)
    }

    func addContraints() {
        titleStack.anchor(height: 36)
        grid.anchorTo(superview: chartView)
        anchor(width: 343, height: 248)
    }

    func addAdditionalConfiguration() {
        axis = .vertical
        spacing = theme.spacing.spacing12
        setCustomSpacing(0, after: chartView)
    }
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 343, height: 248)) {
    let view = BarChartView().setupView().anchor(width: 343, height: 248).setup(with: [
        BarChartViewData(value: 12365.21, title: "R$ 12.365,21", subtitle: "Outubro"),
        BarChartViewData(value: 10231.10, title: "R$ 10.231,10", subtitle: "Novembro"),
        BarChartViewData(value: 12987.63, title: "R$ 12.987,63", subtitle: "Dezembro")
    ])

    return view
}
