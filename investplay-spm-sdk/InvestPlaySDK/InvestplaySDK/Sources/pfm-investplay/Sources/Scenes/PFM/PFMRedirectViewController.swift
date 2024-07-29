//
//  PFMRedirectViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 18/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

class PFMRedirectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        mainStackView.anchorTo(superview: view)
    }
    
    var dismissAction: (() -> Void)?
    
    lazy var feedbackView: UDSFeedback = {
        let view = UDSFeedback(
            style: .emptyState,
            iconImage: UDSAssets.udsOpen.image
        )
        
        view.configure(
            icon: UDSAssets.udsOpen.image,
            title: "Traga seus dados via Open Finance",
            description: "Acesse todas as suas finanças no Gerenciador Financeiro da Unicred. Para adicionar suas contas e cartões de outras intituições, traga seus dados pelo Open Finance."
        )
        
        return view
    }()
    
    lazy var dockedButton: DockerView = {
        let view = DockerView().hideDivider()
        
        view.configure(
            model: DockerViewModel(
                firstButtonTitle: I18n.bringMyData.localized,
                secondButtonTitle: "Voltar"
            )
        )
        
        view.firstButton.addTarget(
            self,
            action: #selector(didTapBringData),
            for: .touchUpInside
        )
        
        view.secondButton.addTarget(
            self,
            action: #selector(dismissView),
            for: .touchUpInside
        )
        
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                feedbackView,
                dockedButton
            ]
        )
        
        stackView.axis = .vertical
        stackView.spacing = 48
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    @objc func dismissView() {
        dismissAction?()
    }
    
    @objc func didTapBringData() {
        Investplay.openFinanceDelegate?.didTapBringData()
        dismissView()
    }
}
