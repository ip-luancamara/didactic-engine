//
//  PFMDateSelectionView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 16/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

protocol PFMDateSelectionViewDelegate: AnyObject {
    func didSelectMonth(_ month: Int)
    func didSelectYear(_ year: Int)
}

class PFMDateSelectionView: UIStackView, ViewCode {
    
    weak var delegate: PFMDateSelectionViewDelegate?
    
    var selectedMonth: Int {
        didSet {
            disableFutureMonths()
        }
    }
    
    var selectedYear: Int {
        didSet {
            disableFutureMonths()
        }
    }
    
    init(selectedMonth: Int, selectedYear: Int) {
        self.selectedMonth = selectedMonth
        self.selectedYear = selectedYear
        super.init(frame: .zero)
        
        defer {
            disableFutureMonths()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var monthSelectionLabel: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(labelStyle: .xSmall)
        view.configure(headingText: I18n.monthSelect.localized, headingColor: .primary600)
        return view
    }()
    
    lazy var yearSelectionLabel: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(labelStyle: .xSmall)
        view.configure(headingText: I18n.yearSelect.localized, headingColor: .primary600)
        return view
    }()
    
    lazy var monthTagsView: TagView = {
        let view = TagView(selected: selectedMonth - 1)
        view.tagNames = Calendar.ptBR.monthSymbols.map({ $0.capitalized })
        view.delegate = self
        return view
    }()
    
    lazy var yearTagsView: TagView = {
        let currentYear = Date().year
        let limit = currentYear - 4
        let tagNames = (limit...currentYear).reversed().map({ $0.description })
        let view = TagView(selected: tagNames.firstIndex(of: selectedYear.description) ?? 0)
        view.tagNames = tagNames
        view.delegate = self
        return view
    }()
    
    func buildViewHierachy() {
        addArrangedSubviews(arrangedSubviews: [
            monthSelectionLabel,
            monthTagsView,
            yearSelectionLabel,
            yearTagsView
        ])
    }
    
    func addContraints() {
        axis = .vertical
        layoutMargins = .init(x: 16)
        isLayoutMarginsRelativeArrangement = true
    }
    
    func disableFutureMonths() {
        let currentYear = Date().year
        let currentMonth = Date().month
        
        guard selectedYear == currentYear else {
            monthTagsView.subviews.forEach({ ($0 as? UDSChip)?.isEnabled = true })
            return
        }
        
        monthTagsView.subviews.suffix(12 - currentMonth.toInt).forEach({ ($0 as? UDSChip)?.isEnabled = false })
            
        guard selectedMonth > currentMonth, let currentMonthTag = monthTagsView.subviews[currentMonth.toInt - 1] as? UDSChip else { return }
        
        monthTagsView.didSelect(chip: currentMonthTag)
    }
}

extension PFMDateSelectionView: TagViewDelegate {
    func didSelect(tag: Int, sender tagView: TagView) {
        switch tagView {
        case monthTagsView:
            selectedMonth = tag + 1
            delegate?.didSelectMonth(selectedMonth)
        case yearTagsView:
            selectedYear = Int(tagView.tagNames[tag]) ?? 0
            delegate?.didSelectYear(selectedYear)
        default:
            break
        }
    }
}
