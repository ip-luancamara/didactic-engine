//
//  PFMAccountSelectionViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 09/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

protocol PFMItemSelectionDelegate: AnyObject {
    func didSelect(item: PFMSelectionItem)
    func didSelect(month: Int, year: Int)
    func didTapCleanFilter()
}

extension PFMItemSelectionDelegate {
    func didSelect(item: PFMSelectionItem) { }
    func didSelect(month: Int, year: Int) { }
    func didTapCleanFilter() { }
}

enum PFMItemType: Equatable {
    case accounts([AccountBase])
    case cards([CreditCard])
    case date
    case transaction

    var isAccounts: Bool {
        switch self {
        case .accounts:
            return true
        default:
            return false
        }
    }
    
    var title: I18n? {
        switch self {
        case .accounts:
            return .myAccounts
        case .cards:
            return .myCards
        case .date:
            return nil
        case .transaction:
            return .movementTypeFilterTitle
        }
    }
    
    func getIndexOfID(selectedID: String) -> Int? {
        switch self {
        case .accounts(let accounts):
            return accounts.firstIndex(where: { $0.id == selectedID })
        case .cards(let cards):
            return cards.firstIndex(where: { $0.id == selectedID })
        default:
            return nil
        }
    }
}

class PFMItemSelectionViewController: UIViewController {

    let type: PFMItemType
    let selectedIndex: Int?
    
    var monthSelection: Int = Date().month.toInt
    var yearSelection: Int = Date().year.toInt

    private var selected: PFMSelectionItem?

    var dismiss: (() -> Void)?

    var items: [PFMSelectionItem] {
        switch type {
        case .accounts(let accounts):
            accounts.map({
                PFMSelectionItem(
                    id: $0.id,
                    imageURL: $0.imageURL,
                    title: $0.bankName,
                    subtitle: $0.accountNumber,
                    type: .service
                )
            })
        case .cards(let cards):
            cards.map({
                PFMSelectionItem(
                    id: $0.id,
                    imageURL: "",
                    title: "\($0.bankName.capitalized) \($0.level)",
                    subtitle: "Final \($0.endNumber)",
                    type: .service
                )
            })
        case .date:
            []
        case .transaction:
            [
                PFMSelectionItem(
                    id: "0",
                    imageURL: "",
                    icon: "uds-coin-down",
                    title: I18n.entries.localized,
                    subtitle: "",
                    type: .movement
                ),
                PFMSelectionItem(
                    id: "1",
                    imageURL: "",
                    icon: "uds-coin-up",
                    title: I18n.exits.localized,
                    subtitle: "",
                    type: .movement
                )
            ]
        }
    }

    weak var delegate: PFMItemSelectionDelegate?

    var mainView: PFMItemSelectionView {
        guard let view = view as? PFMItemSelectionView else { fatalError("MainView type error") }
        return view
    }

    init(
        type: PFMItemType,
        selectedIndex: Int?
    ) {
        self.type = type
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    init(
        type: PFMItemType,
        selectedYear: Int,
        selectedMonth: Int
    ) {
        self.type = type
        self.selectedIndex = nil
        self.yearSelection = selectedYear
        self.monthSelection = selectedMonth
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = PFMItemSelectionView().setupView().setup(
            with: type,
            and: items,
            selected: selectedIndex,
            delegate: self,
            title: type.title
        )
    }

}

extension PFMItemSelectionViewController: PFMItemSelectionViewDelegate {
    var selectedMonth: Int? {
        get {
            return monthSelection
        }
        set {
            guard let newValue else { return }
            monthSelection = newValue
        }
    }
    
    var selectedYear: Int? {
        get {
            return yearSelection
        }
        set {
            guard let newValue else { return }
            yearSelection = newValue
        }
    }
    
    func didTapFilter() {
        defer {
            dismiss?()
        }
        guard let selected else {
            delegate?.didSelect(month: monthSelection, year: yearSelection)
            return
        }
        delegate?.didSelect(item: selected)
    }

    func didTapRadioButton(button: ListItemRadio) {
        mainView.itemStack.arrangedSubviews.filter({
            $0 != button
        }).forEach({
            (
                $0 as? ListItemRadio
            )?.isSelected = false
        })

        button.isSelected.toggle()

        selected = button.isSelected ? items[button.tag] : nil
    }
    
    func didTapCleanFilter() {
        defer {
            dismiss?()
        }
        delegate?.didTapCleanFilter()
    }

}
