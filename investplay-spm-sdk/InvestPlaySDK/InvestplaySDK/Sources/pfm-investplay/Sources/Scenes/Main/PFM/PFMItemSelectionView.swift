//
//  PFMAccountSelectionView.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 09/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import UIKit
@_implementationOnly import DesignSystem

enum PFMSelectionItemType {
    case date
    case movement
    case service
}

struct PFMSelectionItem {
    let id: String
    let imageURL: String
    let icon: String?
    let title: String
    let subtitle: String
    let type: PFMSelectionItemType
    
    init(
        id: String,
        imageURL: String,
        icon: String? = nil,
        title: String,
        subtitle: String,
        type: PFMSelectionItemType
    ) {
        self.id = id
        self.imageURL = imageURL
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}

protocol PFMItemSelectionViewDelegate: AnyObject {
    var selectedMonth: Int? { get set }
    var selectedYear: Int? { get set }
    func didTapRadioButton(button: ListItemRadio)
    func didTapFilter()
    func didTapCleanFilter()
}

class PFMItemSelectionView: UIStackView, ViewCode {

    weak var delegate: PFMItemSelectionViewDelegate?

    lazy var header: UDSTypographySetHeading = {
        let view = UDSTypographySetHeading(labelStyle: .xSmall)
        return view
    }()

    lazy var headerStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [header])
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(x: 16)
        return view
    }()

    lazy var itemStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var dockedButton: DockerView = {
        let view = DockerView().hideDivider()
        
        view.configure(
            model: DockerViewModel(
                firstButtonTitle: I18n.filter.localized,
                secondButtonTitle: I18n.cleanFilter.localized
            )
        )
        
        view.firstButton.addTarget(
            self,
            action: #selector(
                didTapFilterButton
            ),
            for: .touchUpInside
        )
        
        view.secondButton.addTarget(
            self,
            action: #selector(
                didTapCleanFilterButton
            ),
            for: .touchUpInside
        )
        
        return view
    }()

    func makeRadioItem(
        for item: PFMSelectionItem,
        showDivider: Bool,
        isSelected: Bool = false,
        index: Int
    ) -> ListItemRadio {
        let view = ListItemRadio()

        view.addTarget(
            self,
            action: #selector(
                didTapRadioButton
            ),
            for: .touchUpInside
        )
        
        view.isSelected = isSelected
        
        if let icon = item.icon {
            view.configure(
                model: ListItemRadioViewModel(
                    avatarModel: UDSAvatarModel(icon: .init(asset: ImageAsset.getAsset(by: icon), style: icon.contains("up") ? .negative : .positive)),
                    labelText: item.title,
                    descriptorText: item.subtitle,
                    isHiddenDiver: showDivider
                )
            )
            
        } else {
            view.configure(
                model: ListItemRadioViewModel(
                    avatarModel: UDSAvatarModel(
                        urlImage: URL(
                            string: item.imageURL
                        )
                    ),
                    labelText: item.title,
                    descriptorText: item.subtitle,
                    isHiddenDiver: showDivider
                )
            )
        }

        view.tag = index

        view.tintColor = UDSColors.grey500.color

        return view
    }

    func setup(
        with type: PFMItemType,
        and items: [PFMSelectionItem],
        selected: Int? = nil,
        delegate: PFMItemSelectionViewDelegate?,
        title: I18n?
    ) -> Self {
        self.delegate = delegate
        
        dockedButton.secondButton.isHidden = type != .transaction
        
        if type == .date {
            guard let month = delegate?.selectedMonth, let year = delegate?.selectedYear else {
                return self
            }
            
            header.isHidden = true
            
            let dateSelectionView = PFMDateSelectionView(
                selectedMonth: month,
                selectedYear: year
            ).setupView()
            
            dateSelectionView.delegate = self
            
            itemStack.addArrangedSubview(
                dateSelectionView
            )
            
            return self
        }
        
        guard let title else { return self }
        
        itemStack.addArrangedSubviews(
            arrangedSubviews: items.enumerated().map({
                makeRadioItem(
                    for: $0.element,
                    showDivider: $0.offset == items.endIndex - 1,
                    isSelected: selected == $0.offset,
                    index: $0.offset
                )
            })
        )

        header.configure(headingText: title.localized, headingColor: .green600)
        header.isHidden = false
        
        return self
    }

    @objc func didTapRadioButton(button: ListItemRadio) {
        delegate?.didTapRadioButton(button: button)
    }

    @objc func didTapFilterButton() {
        delegate?.didTapFilter()
    }
    
    @objc func didTapCleanFilterButton() {
        delegate?.didTapCleanFilter()
    }

    func buildViewHierachy() {
        addArrangedSubviews(arrangedSubviews: [
            headerStack,
            itemStack,
            dockedButton
        ])
    }

    func addContraints() {
        [
            headerStack,
            itemStack,
            dockedButton
        ].forEach({
            $0.anchor(
                left: safeAreaLayoutGuide.leftAnchor,
                right: safeAreaLayoutGuide.rightAnchor
            )
        })
    }

    func addAdditionalConfiguration() {
        axis = .vertical
        alignment = .center
        setCustomSpacing(24, after: itemStack)
    }
}

extension PFMItemSelectionView: PFMDateSelectionViewDelegate {
    func didSelectMonth(_ month: Int) {
        delegate?.selectedMonth = month
    }
    
    func didSelectYear(_ year: Int) {
        delegate?.selectedYear = year
    }
}


@available(iOS 17.0, *)
#Preview("PFMAccountSelectionView", traits: .portrait) {
    let accounts = [
        AccountBase(
            id: "0",
            bankName: "Unicred",
            // swiftlint:disable:next line_length
            imageURL: "https://scontent.fcgh67-1.fna.fbcdn.net/v/t39.30808-6/304158108_596878735476035_6877993361098203743_n.png?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=Ym-9eh_1XvAAb4j1eGp&_nc_ht=scontent.fcgh67-1.fna&oh=00_AfAAsBVjVk7Lk9rnzGBUjvaDrkNFN7Jy-7SPjPblgWjmDA&oe=661B6214",
            accountNumber: "84657285-3"
        ),
        AccountBase(
            id: "0",
            bankName: "Nubank",
            imageURL: "https://t.ctcdn.com.br/DIEw0gGtQl_GNhWXJwgrRmuGpIk=/i624750.png",
            accountNumber: "84657285-3"
        )
    ]

    let view = PFMItemSelectionView().setupView().setup(
        with: .date,
        and: accounts.map({
            PFMSelectionItem(
                id: "0",
                imageURL: $0.imageURL,
                title: $0.bankName,
                subtitle: $0.accountNumber,
                type: .date
            )
        }),
        delegate: nil,
        title: .myCards
    )

    view.anchor(width: UIScreen.main.bounds.width)

    return view
}
