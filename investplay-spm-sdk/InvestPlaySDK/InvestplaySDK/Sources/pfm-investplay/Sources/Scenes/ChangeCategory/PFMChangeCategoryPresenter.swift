//
//  PFMChangeCategoryPresenter.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 27/05/24.
//  Copyright (c) 2024 Investplay. All rights reserved.
//


import UIKit
@_implementationOnly import DesignSystem

protocol PFMChangeCategoryPresentationLogic {
    func presentCategories(
        response: PFMChangeCategory.GetCategories.Response
    )
    func presentChangeCategory(
        response: PFMChangeCategory.ChangeCategory.Response
    )
    func presentLoading(response: PFMChangeCategory.Loading.Response)
}

class PFMChangeCategoryPresenter: PFMChangeCategoryPresentationLogic {
    weak var viewController: PFMChangeCategoryDisplayLogic?
    
    init(viewController: PFMChangeCategoryDisplayLogic? = nil) {
        self.viewController = viewController
    }
    
    func presentCategories(
        response: PFMChangeCategory.GetCategories.Response
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            viewController?.displayCategories(
                viewModel: PFMChangeCategory.GetCategories.ViewModel(
                    categories: response.categories.enumerated().map({
                        return (
                            viewModel: PFMCategory(
                                title: $0.element.name,
                                icon: ImageAsset.getAsset(
                                    by: $0.element.iconName ?? .empty
                                ).image,
                                showDivider: $0.offset != response.categories.endIndex - 1,
                                indicatorColor: UIColor(
                                    hexString: $0.element.color
                                ),
                                tag: $0.element.id == response.selectedCategoryId ? UDSTagModel(
                                    title: I18n.currentCategory.localized,
                                    style: .info(
                                        highPriority: false
                                    )
                                ) : nil,
                                delegate: response.delegate
                            ),
                            id: $0.element.id
                        )
                    }),
                    selectedCategoryName: response.selectedCategoryName
                )
            )
        }
    }
    
    func presentChangeCategory(
        response: PFMChangeCategory.ChangeCategory.Response
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayChangeCategory(
                viewModel: PFMChangeCategory.ChangeCategory.ViewModel(
                    success: response.success
                )
            )
        }
    }
    
    func presentLoading(response: PFMChangeCategory.Loading.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayLoading(
                viewModel: PFMChangeCategory.Loading.ViewModel()
            )
        }
    }
}
