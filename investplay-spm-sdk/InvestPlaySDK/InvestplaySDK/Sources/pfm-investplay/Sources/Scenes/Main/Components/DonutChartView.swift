//
//  DonutChartView.swift
//
//
//  Created by Luan Câmara on 05/03/24.
//

import UIKit
@_implementationOnly import DesignSystem

typealias DonutChartDataEntry = DonutChartData<Double>

typealias DonutChartDataEntryWithRadians = DonutChartData<Double>

struct DonutChartData<T> {
    let value: T
    let color: UIColor
}

enum DonutChartSegmentSpacing {
    case joined
    case spaced
}

enum DonutChartType {
    case expenseIndicator
    case categoryHeader
}

class DonutChartView: UIView {

    var isLoading: Bool = false {
        didSet {
            guard isLoading else {
                hideLoading()
                setNeedsLayout()
                return
            }
            
            showLoading()
        }
    }
    
    private var type: DonutChartType = .expenseIndicator {
        didSet {
            setNeedsLayout()
        }
    }

    var dataEntries: [DonutChartDataEntry] {
        didSet {
            let values = dataEntries.map { CGFloat($0.value) }
            segmentColors = dataEntries.map { $0.color }
            segmentDegrees = dataEntries.map { ($0.value / values.sum) * 360 }
            setNeedsLayout()
        }
    }

    init(
        dataEntries: [DonutChartDataEntry] = [],
        lineWidth: CGFloat = 20
    ) {
        self.dataEntries = dataEntries
        self.lineWidth = lineWidth
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    func setup(
        data: [DonutChartDataEntry] = [],
        type: DonutChartType = .expenseIndicator
    ) -> Self {
        self.type = type
        dataEntries = ((data.count == 1 && data.first?.value == 0) || data.isEmpty) ? [DonutChartDataEntry(value: 1, color: UDSColors.grey100.color)] : data
        lineCap = dataEntries.count == 1 && type == .expenseIndicator ? .square : .round
        return self
    }

    private var segmentDegrees: [CGFloat] = [] {
        didSet {
            var numberOfSegments: Int = 0

            if let sublayers = layer.sublayers {
                numberOfSegments = sublayers.count
                if numberOfSegments > segmentDegrees.count {
                    for _ in 0..<numberOfSegments - segmentDegrees.count {
                        sublayers.last?.removeFromSuperlayer()
                    }
                }
            }

            while numberOfSegments < segmentDegrees.count {
                let caLayer = CAShapeLayer()
                caLayer.fillColor = UIColor.clear.cgColor
                layer.addSublayer(
                    caLayer
                )

                numberOfSegments += 1
            }
            
            setNeedsLayout()
        }
    }

    private var segmentColors: [UIColor] = [] {
        didSet {
            setNeedsLayout()
        }
    }

    var lineWidth: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }

    var lineCap: CAShapeLayerLineCap = .round {
        didSet {
            setNeedsLayout()
        }
    }

    var lineSpace: DonutChartSegmentSpacing = .joined {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let subs = layer.sublayers else {
            return
        }

        let radius = (
            bounds.size.width - lineWidth
        ) * 0.5

        let center = CGPoint(
            x: bounds.midX,
            y: bounds.midY
        )

        let delta: CGFloat = lineCap == .round ? asin(
            lineWidth * 0.5 / radius
        ) * 0.5 : (lineSpace == .spaced ? 0.02 : 0)

        var startDegrees: CGFloat = type == .expenseIndicator ? -(segmentDegrees.first ?? 0) - 90 : -90

        segmentDegrees.enumerated().forEach { (index, element) in
            let endDegrees = startDegrees + element

            guard let shape = subs[index] as? CAShapeLayer else {
                return
            }

            shape.lineWidth = lineWidth
            shape.lineCap = lineCap
            shape.strokeColor = segmentColors[index % segmentColors.count].cgColor

            let path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: startDegrees.radians + delta,
                endAngle: endDegrees.radians - delta,
                clockwise: true
            )

            shape.path = path.cgPath

            startDegrees += element
        }
    }
}

extension DonutChartView: Loadable {
    func showLoading() {
        setup()
    }
    
    func hideLoading() {
        
    }
}
