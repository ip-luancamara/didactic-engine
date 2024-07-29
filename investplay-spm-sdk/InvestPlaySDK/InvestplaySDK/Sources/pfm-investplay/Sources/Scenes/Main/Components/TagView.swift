//
//  TagView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 16/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

protocol TagViewDelegate: AnyObject {
    func didSelect(tag: Int, sender: TagView)
}

class TagView: UIView {
    
    weak var delegate: TagViewDelegate?
    
    init(
        selected: Int
    ) {
        self.selected = selected
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tagNames: [String] = [] {
        didSet {
            addTagLabels()
        }
    }
    
    var selected: Int {
        didSet {
            delegate?.didSelect(tag: selected, sender: self)
        }
    }
    
    let tagHeight: CGFloat = 32
    let tagPadding: CGFloat = 16
    let tagSpacingX: CGFloat = 12
    let tagSpacingY: CGFloat = 16

    var intrinsicHeight: CGFloat = 0

    func addTagLabels() {
        
        while subviews.count > tagNames.count {
            subviews[0].removeFromSuperview()
        }
        
        while subviews.count < tagNames.count {
            let view = UDSChip()
            view.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
            addSubview(view)
        }

        for ((index, tagName), label) in zip(tagNames.enumerated(), subviews) {
            guard let label = label as? UDSChip else {
                fatalError("non-UDSChip subview found!")
            }
            
            label.isSelected = index == selected
            label.configure(title: tagName)
            label.frame.size.width = label.intrinsicContentSize.width + tagPadding
            label.frame.size.height = tagHeight
            label.tag = index
        }

    }
    
    func displayTagLabels() {
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0

        subviews.forEach {
            
            guard let label = $0 as? UDSChip else {
                fatalError("non-UDSChip subview found!")
            }

            if currentOriginX + label.frame.width > bounds.width {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }
            
            label.frame.origin.x = currentOriginX
            label.frame.origin.y = currentOriginY
            currentOriginX += label.frame.width + tagSpacingX
        }
        
        intrinsicHeight = currentOriginY + tagHeight
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        var sz = super.intrinsicContentSize
        sz.height = intrinsicHeight
        return sz
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayTagLabels()
    }
    
    @objc func didSelect(chip: UDSChip) {
        subviews.filter({ $0 != chip }).forEach({
            ($0 as? UDSChip)?.isSelected = false
        })
        
        chip.isSelected.toggle()
        
        if chip.isSelected {
            selected = chip.tag
        }
    }
}
