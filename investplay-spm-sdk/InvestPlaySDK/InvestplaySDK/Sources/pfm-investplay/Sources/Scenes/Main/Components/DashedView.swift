//
//  DashedView.swift
//
//
//  Created by Luan Câmara on 14/03/24.
//

import UIKit

class DashedView: UIView {

    struct Configuration {
        var color: UIColor
        var dashLength: CGFloat
        var dashGap: CGFloat

        static let `default`: Self = .init(
            color: .lightGray,
            dashLength: 7,
            dashGap: 3
        )
    }

    // MARK: - Properties

    /// Override to customize height
    class var lineHeight: CGFloat { 1.0 }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Self.lineHeight)
    }

    final var config: Configuration = .default {
        didSet {
            drawDottedLine()
        }
    }

    @discardableResult
    final func setup(
        with config: Configuration
    ) -> Self {
        self.config = config
        return self
    }

    private var dashedLayer: CAShapeLayer?

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        // We only redraw the dashes if the width has changed.
        guard bounds.width != dashedLayer?.frame.width else { return }

        drawDottedLine()
    }

    // MARK: - Drawing

    private func drawDottedLine() {
        if dashedLayer != nil {
            dashedLayer?.removeFromSuperlayer()
        }

        dashedLayer = drawDottedLine(
            start: bounds.origin,
            end: CGPoint(x: bounds.width, y: bounds.origin.y),
            config: config
        )
    }

}

private extension DashedView {
    func drawDottedLine(
        start: CGPoint,
        end: CGPoint,
        config: Configuration) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = config.color.cgColor
        shapeLayer.lineWidth = Self.lineHeight
        shapeLayer.lineDashPattern = [config.dashLength as NSNumber, config.dashGap as NSNumber]

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)

        return shapeLayer
    }
}
