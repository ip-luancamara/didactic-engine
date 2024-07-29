//
//  CreditCardCarroucel.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 10/06/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
@_implementationOnly import DesignSystem
import UIKit

class CreditCardCaroucel: UIStackView, Loadable {
    
    var isLoading: Bool = false {
        didSet {
            guard isLoading else {
                hideLoading()
                return
            }
            
            showLoading()
        }
    }
    
    func showLoading() {
        cardsHeader.isLoading = true
        collectionView.isHidden = true
    }
    
    func hideLoading() {
        cardsHeader.isLoading = false
        collectionView.isHidden = false
    }
    
    lazy var cardsHeader: BalanceHeaderView = {
        BalanceHeaderView().setupView()
    }()
    
    weak var delegate: UDSBalanceCreditCardViewModelDelegate?

    var hideValues: Bool = false {
        didSet {
            cardsHeader.hideValues = hideValues
            collectionView.reloadData()
        }
    }

    private var creditCards: [CreditCard] = []

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(x: theme.spacing.spacing16, y: 0)
        flowLayout.minimumLineSpacing = theme.spacing.spacing16 * 2
        flowLayout.minimumInteritemSpacing = theme.spacing.spacing16 * 2
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.register(CreditCardCell.self)
        view.register(ConnectCreditCardCell.self)
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
        with cards: [CreditCard],
        delegate: UDSBalanceCreditCardViewModelDelegate?
    ) -> Self {
        self.delegate = delegate
        
        creditCards = cards

        pagination.configure(
            count: creditCards.count > 0 ? creditCards.count : 1,
            selectedIndex: currentPage
        )
        
        collectionView.reloadData()
        
        guard !creditCards.isEmpty else { return self }
        
        collectionView.scrollToItem(
            at: IndexPath(
                item: currentPage,
                section: 0
            ),
            at: .centeredHorizontally,
            animated: false
        )
        
        return self
    }
}

extension CreditCardCaroucel: ViewCode {

    func buildViewHierachy() {
        addArrangedSubviews(
            arrangedSubviews: [
                cardsHeader,
                collectionView,
                pagination
            ]
        )
    }

    func addContraints() {
        collectionView.anchor(height: 249)
        
        [
            cardsHeader,
            collectionView,
        ].forEach({
            $0.anchorXTo(
                in: self
            )
        })
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

extension CreditCardCaroucel: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        creditCards.isEmpty ? 1 : creditCards.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        delegate?.didTapBalanceCreditCard(index: indexPath.item)
    }
}

// MARK: - Card Collection DataSource

extension CreditCardCaroucel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard creditCards.isEmpty else {
            return collectionView.dequeueReusableCell(
                of: CreditCardCell.self,
                for: indexPath
            ).setupView().setup(
                with: creditCards[indexPath.item],
                hideValues: hideValues
            )
        }
        
        return collectionView.dequeueReusableCell(
            of: ConnectCreditCardCell.self,
            for: indexPath
        ).setupView()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: UIScreen.main.bounds.width - theme.spacing.spacing16 * 2,
            height: 249
        )
    }
}

extension CreditCardCaroucel: UIScrollViewDelegate {
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
