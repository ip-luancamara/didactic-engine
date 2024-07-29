//
//  PFMErrorView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 04/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

enum FeedbackType {
    case unknown
    case firstLoad
    case notSharedData

    var image: UIImage {
        ImageAsset.getAsset(by: iconName).image
    }
    
    var iconName: String {
        switch self {
        case .unknown:
            "uds-neutral-face"
        case .firstLoad:
            "uds-clock"
        case .notSharedData:
            "uds-barchart"
        }
    }

    var title: String {
        switch self {
        case .unknown:
            I18n.tryAgain.localized
        case .firstLoad:
            I18n.feedbackFirstLoadTitle.localized
        case .notSharedData:
            I18n.feedbackNotSharedDataTitle.localized
        }
    }

    var description: String {
        switch self {
        case .unknown:
            I18n.feedbackUnknownDescription.localized
        case .firstLoad:
            I18n.feedbackFirstLoadDescription.localized
        case .notSharedData:
            I18n.feedbackNotSharedDataDescription.localized
        }
    }

    var mainButtonTitle: String {
        switch self {
        case .unknown:
            I18n.tryAgain.localized
        case .firstLoad:
            I18n.goBackToMainScreen.localized
        case .notSharedData:
            I18n.bringMyData.localized
        }
    }
}

class PFMFeedbackView: UIStackView, ViewCode {

    let type: FeedbackType

    init(type: FeedbackType) {
        self.type = type
        super.init(frame: .zero)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var feedback: UDSFeedback = {
        let view = UDSFeedback(
            style: type == .unknown ? .critical : .emptyState,
            iconImage: type.image
        )

        view.configure(
            icon: type.image,
            title: type.title,
            description: type.description
        )

        return view
    }()

    lazy var mainButton: UDSButtonPrimary = {
        let view = UDSButtonPrimary()
        view.setTitle(type.mainButtonTitle, for: .normal)
        view.anchor(width: 220)
        return view
    }()

    lazy var secondaryButton: UDSButtonSecondary = {
        let view = UDSButtonSecondary()
        view.setTitle(I18n.goToMainScreen.localized, for: .normal)
        view.anchor(width: 220)
        view.isHidden = type != .unknown
        view.addTarget(self, action: #selector(goToMainScreen), for: .touchUpInside)
        return view
    }()

    lazy var buttonStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            mainButton,
            secondaryButton
        ])
        view.axis = .vertical
        view.spacing = 24
        return view
    }()

    func buildViewHierachy() {
        addArrangedSubviews(
            arrangedSubviews: [
                feedback,
                .spacer,
                buttonStack
            ]
        )
    }

    func addContraints() {
        feedback.anchor(
            left: layoutMarginsGuide.leftAnchor,
            right: layoutMarginsGuide.rightAnchor
        )
    }

    func addAdditionalConfiguration() {
        axis = .vertical
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(x: 16, y: 24)
    }
    
    @objc func goToMainScreen() {
        Investplay.delegate?.goToMainScreen()
    }

}

@available(iOS 17.0, *)
#Preview("Erro desconhecido", traits: .portrait) {
    let view = PFMFeedbackView(type: .unknown).setupView()
    return view
}

@available(iOS 17.0, *)
#Preview("Primeira carga", traits: .portrait) {
    let view = PFMFeedbackView(type: .firstLoad).setupView()
    return view
}

@available(iOS 17.0, *)
#Preview("Sem dados", traits: .portrait) {
    let view = PFMFeedbackView(type: .notSharedData).setupView()
    return view
}
