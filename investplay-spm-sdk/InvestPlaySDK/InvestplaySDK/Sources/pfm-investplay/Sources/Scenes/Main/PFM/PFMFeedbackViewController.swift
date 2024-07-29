//
//  PFMFeedbackViewController.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 14/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

class PFMFeedbackViewController: UIViewController {
    
    let type: FeedbackType
    
    init(
        type: FeedbackType
    ) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mainView: PFMFeedbackView {
        guard let view = view as? PFMFeedbackView else { fatalError("MainView type error") }
        return view
    }
    
    lazy var titleView: UILabel = {
        let view = UILabel()
        view.text = I18n.financialManager.localized
        view.font = FontFamily.OpenSans.regular.small
        view.textAlignment = .center
        view.textColor = UDSColors.primary600.color
        return view
    }()
    
    override func loadView() {
        view = PFMFeedbackView(
            type: type
        ).setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleView
        
        setNavigationBar(
            appearance: .internally
        )
        
        let backButton = UIBarButtonItem(
            image: UDSAssets.udsClose.image,
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(
                backPrevious
            )
        )
        
        navigationItem.leftBarButtonItem = backButton
    }
}
