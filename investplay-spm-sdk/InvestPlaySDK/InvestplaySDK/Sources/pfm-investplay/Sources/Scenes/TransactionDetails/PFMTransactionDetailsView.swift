//
//  PFMTransactionDetailsView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

enum PFMTransactionDetailsType {
    case entry
    case exit
    
    var title: String {
        switch self {
        case .entry:
            return I18n.entry.localized
        case .exit:
            return I18n.exit.localized
        }
    }
    
    var tagStyle: TagStyle {
        switch self {
        case .entry:
            return .positive(highPriority: false)
        case .exit:
            return .negative(highPriority: false)
        }
    }
}

class PFMTransactionDetailsView: UIStackView, ViewCode {
    
    weak var delegate: UDSItemListSwitchViewModelDelegate?
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            infoStack,
            categoryView,
            switchView,
            .spacer
        ])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 16
        return view
    }()
    
    lazy var infoStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            transactionTitle,
            valueSubtitleLabel,
            valueLabel,
            dateLabel,
            tagStack,
            transactionOriginView
        ])
        view.axis = .vertical
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16)
        view.spacing = 16
        return view.anchorAllToXMargins()
    }()
    
    lazy var snackbar: UDSSnackbar = {
        UDSSnackbar.make(
            in: self,
            message: I18n.categoryChangeSuccessMessage.localized,
            style: .positive,
            direction: .fromTop
        )
    }()
    
    lazy var transactionTitle: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(labelStyle: .small)
        return view
    }()
    
    lazy var valueSubtitleLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.numberOfLines = 1
        view.text = I18n.value.localized
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.bold.huge
        view.numberOfLines = 1
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.small
        view.textColor  = UDSColors.grey600.color
        view.numberOfLines = 1
        return view
    }()
    
    lazy var tagView: TagComponentView = {
        let view = TagComponentView()
        return view
    }()
    
    lazy var tagStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [tagView, .spacer])
        return view
    }()
    
    lazy var transactionOriginView: UDSTypographySetTopic = {
        let view = UDSTypographySetTopic()
        return view
    }()
    
    lazy var categoryView: UDSSpendingAction = {
        let view = UDSSpendingAction()
        return view
    }()
    
    lazy var switchView: UDSItemListSwitch = {
        let view = UDSItemListSwitch()
        return view
    }()
    
    @discardableResult
    func setup(
        type: PFMTransactionDetailsType,
        title: String,
        value: String,
        date: String,
        fromTitle: String,
        fromSubtitle: String,
        fromImageURL: String,
        category: UDSSpendingActionViewModel,
        isIgnored: Bool
    ) -> Self {
        switchView.isHidden = type == .entry
        
        valueLabel.text = value
        
        tagView.configure(
            text: type.title,
            style: type.tagStyle
        )
        
        switchView.configure(
            with: UDSItemListSwitchViewModel(
                titleText: I18n.switchViewTitle.localized,
                descriptionText: I18n.switchViewSubtitle.localized,
                switchButtonIsOn: isIgnored,
                delegate: self
            )
        )
        
        dateLabel.text = date
        
        transactionTitle.configure(
            headingText: title,
            headingColor: .green600
        )
        
        transactionOriginView.configure(
            paragraphText: fromTitle,
            descriptorText: fromSubtitle,
            avatarModel: UDSAvatarModel(
                urlImage: URL(
                    string: fromImageURL
                )
            )
        )
        
        categoryView.configure(with: category)
        
        mainStack.isHidden = false
        return self
    }
	
    func buildViewHierachy() {
        addSubview(mainStack)
    }

    func addContraints() {
        mainStack.arrangedSubviews.forEach({
            $0.anchor(
                left: mainStack.leftAnchor,
                right: mainStack.rightAnchor
            )
        })

        mainStack.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            left: safeAreaLayoutGuide.leftAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            right: safeAreaLayoutGuide.rightAnchor
        )
    }

    func addAdditionalConfiguration() {
        backgroundColor = .white
        mainStack.isHidden = true
    }
    
    
}

extension PFMTransactionDetailsView: UDSItemListSwitchViewModelDelegate {
    func didSelect(isOn: Bool) {
        delegate?.didSelect(isOn: isOn)
    }
}

@available(iOS 17.0, *)
#Preview("PFMTransactionDetailsView", traits: .portrait) {
    let view = PFMTransactionDetailsView().setupView()
    return view
}

