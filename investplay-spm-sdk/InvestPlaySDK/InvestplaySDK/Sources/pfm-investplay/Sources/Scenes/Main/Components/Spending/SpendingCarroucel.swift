//
//  SpendingCaroucel.swift
//
//
//  Created by Luan Câmara on 13/03/24.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit

protocol SpendingCarroucelDelegate: AnyObject {
    func didSelectSpendingCard(at index: Int, categoryID: String)
}

class SpendingCaroucel: UIStackView {
    
    weak var delegate: SpendingCarroucelDelegate?

    var hideValues: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }

    private var spendingCards: [SpendingCaroucelCardViewModel] = []

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 488)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.clear
        view.collectionViewLayout = flowLayout
        view.isPagingEnabled = true
        view.register(SpendingCell.self)
        return view
    }()

    private let theme = Theme()

    private let pagination: UDSPaginationView = {
        let view = UDSPaginationView()
        view.setup(style: .primary)
        return view
    }()

    var currentPage: Int = 0 {
        didSet {
            pagination.select(index: currentPage)
        }
    }

    @discardableResult
    func setup(
        with cards: [SpendingCaroucelCardViewModel],
        shouldResetScroll: Bool = true
    ) -> Self {
        self.delegate = delegate
        
        spendingCards = cards
        
        collectionView.reloadData()
        
        guard !cards.isEmpty else { return self }
        
        if shouldResetScroll {
            currentPage = cards.endIndex - 1

            pagination.configure(
                count: cards.count,
                selectedIndex: currentPage
            )
            
            collectionView.scrollToItem(
                at: IndexPath(
                    item: currentPage,
                    section: 0
                ),
                at: .centeredHorizontally,
                animated: false
            )
        }
        
        return self
    }
}

extension SpendingCaroucel: ViewCode {

    func buildViewHierachy() {
        addArrangedSubviews(
            arrangedSubviews: [
                collectionView,
                pagination
            ]
        )
    }

    func addContraints() {
        collectionView.anchorXTo(in: self)
        collectionView.anchor(height: 488)
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

extension SpendingCaroucel: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        spendingCards.count
    }
}

// MARK: - Card Collection DataSource

extension SpendingCaroucel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            of: SpendingCell.self,
            for: indexPath
        ).setupView().setup(
            with: spendingCards[indexPath.row],
            hideValues: hideValues,
            delegate: self
        )
    }
}

extension SpendingCaroucel: UIScrollViewDelegate {
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
        }
    }
}

extension SpendingCaroucel: UDSSpendingViewModelDelegate {
    func didTapView(
        sender: UDSSpending
    ) {
        delegate?.didSelectSpendingCard(
            at: currentPage,
            categoryID: sender.accessibilityIdentifier ?? .empty
        )
    }
}
