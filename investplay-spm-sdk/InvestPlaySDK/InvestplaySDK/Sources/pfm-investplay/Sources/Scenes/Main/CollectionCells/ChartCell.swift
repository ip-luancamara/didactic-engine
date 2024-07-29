//
//  ChartCell.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 16/02/24.
//

import UIKit
@_implementationOnly import DesignSystem

class ChartCell: UICollectionViewCell, ViewCode {
    
    var isLoading: Bool = false {
        didSet {
            guard isLoading else {
                return hideLoading()
            }
            
            showLoading()
        }
    }

    let theme = Theme()

    lazy var donutChart: DonutChartView = {
        DonutChartView().anchor(
            width: 200,
            height: 200
        )
    }()
    
    lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()

    lazy var descriptionView: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.xx_small
        view.textAlignment = .center
        view.textColor = UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 1)
        return view
    }()

    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleView, descriptionView])
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .center
        return view
    }()

    lazy var barsChart = BarChartView().setupView().anchor(width: 343, height: 248)

    func buildViewHierachy() { }

    func addContraints() { }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeAllSubviews()
    }

    @discardableResult
    func setup(
        with viewModel: ChartsCarroucelCardViewModel,
        hideValues: Bool,
        delegate: ChartsCarroucelDelegate? = nil
    ) -> Self {
        switch viewModel.type {
        case .donut(let color):
            addSubview(donutChart)
            addSubview(titleStack)
            donutChart.anchorCenterSuperview()
            titleStack.anchorCenterSuperview()
            
            guard let data = viewModel.data.first else {
                donutChart.setup()
                return self
            }
            
            titleView.text = hideValues ? I18n.hiddenValue.localized : data.value.formattedAsBRL()
            descriptionView.text = data.subtitle
            
            let monthMedium = viewModel.threeMonthTotal / 3
            let fillingPercentage = data.value / monthMedium
            let needToFillAllChart = fillingPercentage.isNaN || fillingPercentage >= 1
            
            donutChart.setup(
                data: needToFillAllChart ? [
                    DonutChartDataEntry(
                        value: data.value,
                        color: color
                    )
                ] : [
                    DonutChartDataEntry(
                        value: monthMedium,
                        color: theme.colors.grey100
                    ),
                    DonutChartDataEntry(
                        value: data.value,
                        color: color
                    )
                ]
            )
        case .bars:
            barsChart.setup(
                with: viewModel.data.map({
                    BarChartViewData(
                        value: $0.value,
                        title: hideValues ? I18n.hiddenValue.localized : $0.title,
                        subtitle: $0.subtitle
                    )
                }),
                delegate: delegate
            )

            addSubview(barsChart)

            barsChart.anchorCenterSuperview()
        }

        return self
    }
}

extension ChartCell: Loadable {
    func showLoading() {
        setup(
            with: .empty,
            hideValues: false
        )
        
        titleStack.isHidden = true
    }
    
    func hideLoading() {
        titleStack.isHidden = false
    }
}
