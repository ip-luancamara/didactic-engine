//
//  BankAccountCell.swift
//  InvestPlayApp
//
//  Created by Luan Câmara on 20/02/24.
//  Copyright © 2024 InvestPlay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

class BankAccountCell: UICollectionViewCell, ViewCode {

    lazy var mainView: BankAccountView = {
        BankAccountView(style: .filled).setupView()
    }()

    @discardableResult
    func setup(
        bankName: String = .empty,
        account: String = .empty,
        balance: String = .empty,
        image: String = .empty,
        isValuesHidden: Bool = false
    ) -> Self {
        if bankName.isEmpty, account.isEmpty, balance.isEmpty, image.isEmpty, !isValuesHidden {
            mainView.showSkeleton()
            return self
        }
        
        mainView.hideSkeleton()
        
        mainView.setup(
            bankName: bankName,
            account: account,
            balance: isValuesHidden ? I18n.hiddenValue.localized : balance,
            image: image
        )
        
        return self
    }

    func buildViewHierachy() {
        contentView.addSubview(mainView)
    }

    func addContraints() {
        mainView.anchorTo(superview: contentView)
    }

    func addAdditionalConfiguration() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

}

class BankAccountView: UIView, ViewCode {

    let style: UDSContainerStyle

    init(style: UDSContainerStyle) {
        self.style = style
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var container: UDSContainerView = {
        let view = UDSContainerView(style: style, containerView: mainStack)
        return view
    }()

    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [bankImage, titleStack])
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16, y: 8)
        view.spacing = 16
        view.alignment = .center
        return view
    }()

    lazy var bankLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.x_small
        view.numberOfLines = 1
        return view
    }()

    lazy var accountLabel: UILabel = {
        let view = UILabel()
        view.font = FontFamily.OpenSans.regular.xx_small
        view.textColor = UDSColors.grey600.color
        view.numberOfLines = 1
        return view
    }()

    lazy var balanceLabel: UDSValue = {
        let view = UDSValue()
        view.font = FontFamily.OpenSans.semiBold.x_small
        view.textColor = UDSColors.black.color
        view.numberOfLines = 1
        return view
    }()

    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [bankLabel, accountLabel, balanceLabel])
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .leading
        return view
    }()

    lazy var bankImage: UDSAvatar = {
        UDSAvatar(dimension: .small)
    }()

    @discardableResult
    func setup(
        bankName: String,
        account: String,
        balance: String,
        image: String
    ) -> Self {
        bankImage.configure(with: UDSAvatarModel(urlImage: URL(string: image)))
        bankLabel.text = bankName
        accountLabel.text = account
        balanceLabel.text = balance
        
        let isValuesHidden = balanceLabel.text == I18n.hiddenValue.localized
        
        balanceLabel.accessibilityLabel = isValuesHidden ? "Saldo oculto pelo usuário" : balance
        
        return self
    }

    func buildViewHierachy() {
        addSubview(container)
    }

    func addContraints() {
        container.anchorTo(superview: self)
    }
    
    func addAdditionalConfiguration() {
        isSkeletonable = true
    }

}
