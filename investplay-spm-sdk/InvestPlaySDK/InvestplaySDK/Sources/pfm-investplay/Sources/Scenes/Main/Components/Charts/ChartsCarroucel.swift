//
//  ChartsCarroucel.swift
//
//
//  Created by Luan Câmara on 13/03/24.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit

enum ChartType: Equatable {
    case donut(color: UIColor)
    case bars
}

enum DelegateChartType {
    case donut
    case bars(index: Int)
}

struct ChartData: Equatable {
    let value: Double
    let title: String
    let subtitle: String
}

struct ChartsCarroucelCardViewModel: Equatable {
    let type: ChartType
    let data: [ChartData]
    let threeMonthTotal: Double
    
    static var empty: Self {
        return ChartsCarroucelCardViewModel(
            type: .donut(color: .gray),
            data: [],
            threeMonthTotal: 0
        )
    }
    
    var accessibilityLabel: String {
        data.map { "\($0.title) \($0.subtitle)" }.joined(separator: ", ")
    }
    
    var accessibilityLabelWithHiddenValues: String {
        data.map { "Saldo oculto pelo usuário \($0.subtitle)" }.joined(separator: ", ")
    }
}

protocol ChartsCarroucelDelegate: AnyObject {
    func didTapChart(type: DelegateChartType)
}

class ChartsCarroucel: UIStackView {
    
    var isLoading: Bool = false {
        didSet {
            guard isLoading else {
                return hideLoading()
            }
            
            showLoading()
        }
    }
    
    weak var delegate: ChartsCarroucelDelegate?

    var hideValues = false {
        didSet {
            carouselAccessibilityElement?.isValuesHidden = hideValues
            collectionView.reloadData()
            UIAccessibility.post(notification: .layoutChanged, argument: nil)
        }
    }

    var cards: [ChartsCarroucelCardViewModel] = []
    
    var currentCard: ChartsCarroucelCardViewModel? { cards.count > 0 ? cards[currentPage] : nil }

    lazy var chartsHeader: UIStackView = {
        let view = UIStackView(arrangedSubviews: [header, .spacer])
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16, y: 0)
        return view
    }()

    lazy var header: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(
            customTopAnchor: 20,
            customBottomAnchor: 4
        )

        view.configure(
            headingText: I18n.myExpenses.localized,
            headingColor: .green700
        )

        return view
    }()

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = theme.spacing.spacing16 * 2
        flowLayout.minimumInteritemSpacing = theme.spacing.spacing16 * 2
        flowLayout.sectionInset = UIEdgeInsets(x: theme.spacing.spacing16, y: 0)

        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.clear
        view.collectionViewLayout = flowLayout
        view.isPagingEnabled = true
        view.register(ChartCell.self)
        return view
    }()

    private let theme = Theme()

    private let pagination: UDSPaginationView = {
        let view = UDSPaginationView()
        view.setup(style: .primary)
        view.configure(count: 1, selectedIndex: 0)
        view.isSkeletonable = true
        return view
    }()

    private var currentPage: Int = 0 {
        didSet {
            pagination.select(index: currentPage)
        }
    }

    @discardableResult
    func setup(
        with cards: [ChartsCarroucelCardViewModel]
    ) -> Self {
        defer {
            UIAccessibility.post(notification: .layoutChanged, argument: nil)
        }
        
        self.cards = cards

        pagination.configure(
            count: cards.count,
            selectedIndex: currentPage
        )
        
        carouselAccessibilityElement?.current = currentCard

        collectionView.reloadData()
        
        return self
    }
    
    // MARK: Accessibility

    var carouselAccessibilityElement: CarouselAccessibilityElement?

    // Like in the `DogStatsView`, we need to cache `accessibilityElements`. See that file for an explanation why.
    /// - Tag: using_carousel_accessibility_element
    private var _accessibilityElements: [Any]?

    override var accessibilityElements: [Any]? {
        get {
            guard _accessibilityElements == nil else {
                return _accessibilityElements
            }
            
            guard let currentCard else {
                return _accessibilityElements
            }

            let carouselAccessibilityElement: CarouselAccessibilityElement
            
            if let theCarouselAccessibilityElement = self.carouselAccessibilityElement {
                carouselAccessibilityElement = theCarouselAccessibilityElement
            } else {
                carouselAccessibilityElement = CarouselAccessibilityElement(
                    accessibilityContainer: self,
                    current: currentCard
                )
                
                carouselAccessibilityElement.accessibilityFrameInContainerSpace = collectionView.frame
                self.carouselAccessibilityElement = carouselAccessibilityElement
            }

            _accessibilityElements = [chartsHeader, carouselAccessibilityElement]

            return _accessibilityElements
        }
        
        set {
            _accessibilityElements = newValue
        }
    }
}

extension ChartsCarroucel: Loadable {
    func showLoading() {
        getAllSubviews().forEach({ $0.showSkeleton() })
        setup(with: [.empty])
    }
    
    func hideLoading() {
        getAllSubviews().forEach({ $0.hideSkeleton() })
    }
}

extension ChartsCarroucel: ViewCode {

    func buildViewHierachy() {
        addArrangedSubviews(
            arrangedSubviews: [
                chartsHeader,
                collectionView,
                pagination
            ]
        )
    }

    func addContraints() {
        collectionView.anchorXTo(in: self)
        collectionView.anchor(height: 248)
        chartsHeader.anchorXTo(in: self)
    }

    func addAdditionalConfiguration() {
        alignment = .center
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        axis = .vertical
        spacing = 16
    }
}
// MARK: - Card Collection Delegate

extension ChartsCarroucel: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return isLoading ? 1 : cards.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.item == 0 {
            delegate?.didTapChart(type: .donut)
        }
    }
}

// MARK: - Card Collection DataSource

extension ChartsCarroucel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(
            of: ChartCell.self,
            for: indexPath
        ).setupView()
        
        cell.isAccessibilityElement = true
        
        cell.isLoading = isLoading
        
        guard !isLoading else { return cell }
        
        return cell.setup(
            with: cards[indexPath.row],
            hideValues: hideValues,
            delegate: delegate
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width - theme.spacing.spacing16 * 2,
            height: 248
        )
    }
}

extension ChartsCarroucel: UIScrollViewDelegate {
    func scrollViewDidScroll(
        _ scrollView: UIScrollView
    ) {
        if let indexPath = collectionView.indexPathForItem(
            at:
                CGPoint(
                    x: collectionView.bounds.midX,
                    y: collectionView.bounds.midY
                )
        ) {
            currentPage = indexPath.item
            carouselAccessibilityElement?.current = currentCard
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIAccessibility.post(notification: .layoutChanged, argument: self.carouselAccessibilityElement)
            }
        }
    }
}
