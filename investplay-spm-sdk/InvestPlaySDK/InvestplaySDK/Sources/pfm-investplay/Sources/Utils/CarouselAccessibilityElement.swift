//
//  CarouselAccessibilityElement.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 23/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit

class CarouselAccessibilityElement: UIAccessibilityElement {
    
    // MARK: Properties
    var current: ChartsCarroucelCardViewModel?
    var isValuesHidden: Bool = false

    // MARK: Initializers

    init(accessibilityContainer: Any, current object: ChartsCarroucelCardViewModel?) {
        super.init(accessibilityContainer: accessibilityContainer)
        current = object
    }

    /// This indicates to the user what exactly this element is supposed to be.
    override var accessibilityLabel: String? {
        get {
            return "Carrossel de Gráficos"
        }
        set {
            super.accessibilityLabel = newValue
        }
    }

    override var accessibilityValue: String? {
        get {
            guard let current else { return super.accessibilityValue }
            return isValuesHidden ? current.accessibilityLabelWithHiddenValues : current.accessibilityLabel
        }

        set {
            super.accessibilityValue = newValue
        }
    }

    // This tells VoiceOver that our element will support the increment and decrement callbacks.
    /// - Tag: accessibility_traits
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .adjustable
        }
        set {
            super.accessibilityTraits = newValue
        }
    }

    /**
        A convenience for forward scrolling in both `accessibilityIncrement` and `accessibilityScroll`.
        It returns a `Bool` because `accessibilityScroll` needs to know if the scroll was successful.
    */
    func accessibilityScrollForward() -> Bool {

        // Initialize the container view which will house the collection view.
        guard let containerView = accessibilityContainer as? ChartsCarroucel else {
            return false
        }
        
        // Store the currently focused dog and the list of all dogs.
        guard let current else {
            return false
        }

        // Get the index of the currently focused dog from the list of dogs (if it's a valid index).
        guard let index = containerView.cards.firstIndex(of: current), index < containerView.cards.count - 1 else {
            return false
        }

        // Scroll the collection view to the currently focused dog.
        containerView.collectionView.scrollToItem(
            at: IndexPath(row: index + 1, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        return true
    }

    /**
        A convenience for backward scrolling in both `accessibilityIncrement` and `accessibilityScroll`.
        It returns a `Bool` because `accessibilityScroll` needs to know if the scroll was successful.
    */
    func accessibilityScrollBackward() -> Bool {
        // Initialize the container view which will house the collection view.
        guard let containerView = accessibilityContainer as? ChartsCarroucel else {
            return false
        }
        
        // Store the currently focused dog and the list of all dogs.
        guard let current else {
            return false
        }

        // Get the index of the currently focused dog from the list of dogs (if it's a valid index).
        guard let index = containerView.cards.firstIndex(of: current), index > 0 else {
            return false
        }

        containerView.collectionView.scrollToItem(
            at: IndexPath(row: index - 1, section: 0),
            at: .centeredHorizontally,
            animated: true
        )

        return true
    }

    // MARK: Accessibility

    /*
        Overriding the following two methods allows the user to perform increment and decrement actions
        (done by swiping up or down).
    */
    /// - Tag: accessibility_increment_decrement
    override func accessibilityIncrement() {
        // This causes the picker to move forward one if the user swipes up.
        _ = accessibilityScrollForward()
    }
    
    override func accessibilityDecrement() {
        // This causes the picker to move back one if the user swipes down.
        _ = accessibilityScrollBackward()
    }

    /*
        This will cause the picker to move forward or backwards on when the user does a 3-finger swipe,
        depending on the direction of the swipe. The return value indicates whether or not the scroll was successful,
        so that VoiceOver can alert the user if it was not.
    */
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        if direction == .left {
            return accessibilityScrollForward()
        } else if direction == .right {
            return accessibilityScrollBackward()
        }
        return false
    }

}
