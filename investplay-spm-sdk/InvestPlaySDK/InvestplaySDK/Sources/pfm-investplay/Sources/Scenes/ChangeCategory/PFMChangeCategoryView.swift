//
//  PFMChangeCategoryView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import DesignSystem

class PFMChangeCategoryView: UIScrollView, ViewCode, Loadable {
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
        mainStack.isHidden = true
        loader.startAnimating()
    }
    
    func hideLoading() {
        loader.stopAnimating()
        mainStack.isHidden = false
    }
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            infoStack,
            searchBar,
            errorAlert,
            categoryView
        ])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    lazy var infoStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            title,
            currentCategoryView
        ])
        view.axis = .vertical
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16)
        view.spacing = 8
        return view
    }()
    
    lazy var errorAlert: AlertView = {
        let view = AlertView()
        view.configure(
            with: AlertViewModel(
                titleText: I18n.changeCategoryErrorAlertTitle.localized,
                descriptionText: I18n.changeCategoryErrorAlertDescription.localized,
                alertStyle: .error
            )
        )
        view.isHidden = true
        return view
    }()
    
    lazy var title: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(labelStyle: .small)
        view.configure(headingText: I18n.changeCategoryScreenTitle.localized, headingColor: .primary600)
        return view
    }()
    
    lazy var transactionOriginView: UDSTypographySetTopic = {
        let view = UDSTypographySetTopic()
        return view
    }()
    
    lazy var currentCategoryView: UDSTypographySetResume = {
        let view = UDSTypographySetResume()
        return view
    }()
    
    lazy var searchBar: UDSInputSearch = {
        let view = UDSInputSearch(style: .filled)
        return view
    }()
    
    lazy var categoryView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var loader: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            UIActivityIndicatorView(style: .large)
        } else {
            UIActivityIndicatorView()
        }
    }()
    
    @discardableResult
    func setup(
        with categories: [IdentifiableSpendingViewModel],
        selectedCategory: String? = nil
    ) -> Self {
        categoryView.removeAllArrangedSubviews()
        
        categories.forEach({
            let view = UDSSpendingAction()
            view.configure(with: $0.viewModel.toUDSViewModel())
            view.accessibilityIdentifier = $0.id
            categoryView.addArrangedSubview(view)
        })
        
        if let selectedCategory {
            currentCategoryView.configure(
                paragraphText: I18n.currentCategory.localized,
                descriptorText: selectedCategory
            )
        }
        
        mainStack.isHidden = false
        return self
    }
	
    func buildViewHierachy() {
        addSubview(mainStack)
        addSubview(loader)
    }

    func addContraints() {
        mainStack.anchorAllToXMargins()

        mainStack.anchor(
            top: contentLayoutGuide.topAnchor,
            left: safeAreaLayoutGuide.leftAnchor,
            bottom: contentLayoutGuide.bottomAnchor,
            right: safeAreaLayoutGuide.rightAnchor
        )
        
        loader.anchorTo(superview: self, anchorTo: .safeArea)
        
        infoStack.anchorAllToXMargins()
    }

    func addAdditionalConfiguration() {
        backgroundColor = .white
        mainStack.isHidden = true
        errorAlert.isHidden = true
    }
}

@available(iOS 17.0, *)
#Preview("PFMChangeCategoryView", traits: .portrait) {
    let view = PFMChangeCategoryView().setupView()
    return view
}

