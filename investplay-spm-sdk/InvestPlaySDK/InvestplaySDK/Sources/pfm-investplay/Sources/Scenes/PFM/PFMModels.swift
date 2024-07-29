//
//  PFMModels.swift
//
//
//  Created by Luan Câmara on 20/03/24.
//

import Foundation
import UIKit
import NetworkSdk
@_implementationOnly import DesignSystem

enum PFM {

    enum LoadView {
        struct Request {
            let presentLoading: Bool
            
            init(
                presentLoading: Bool = false
            ) {
                self.presentLoading = presentLoading
            }
        }

        struct Response {
            let services: [Account]
            let cards: [CreditCard]
            let allCardsBalance: Double
            let allAccountsBalance: Double
            let insights: [Insight]
            let spendings: [MonthSpending]
            let spendingChartColor: UIColor
        }

        struct ViewModel {
            let accounts: [Account]
            let cards: [CreditCard]
            let allCardsBalance: Double
            let allAccountsBalance: Double
            let insights: [Insight]
            let spendings: [SpendingCaroucelCardViewModel]
            let charts: [ChartsCarroucelCardViewModel]
        }
    }

    enum SelectService {
        struct Request {
            let index: Int
        }

        struct Response { }

        struct ViewModel { }
    }
    
    enum Feedback {
        struct Request { }

        struct Response { 
            let type: FeedbackType
        }

        struct ViewModel { 
            let type: FeedbackType
        }
    }
    
    enum TransactionsByCategory {
        struct Request { }
        
        struct Response {
            let month: Int
            let year: Int
            let categoryId: String
        }
        
        struct ViewModel {
            let month: Int
            let year: Int
            let categoryId: String
        }
    }
    
    enum AccessAll {
        struct Request { 
            let index: Int
        }
        
        struct Response {
            let month: Int
            let year: Int
        }
        
        struct ViewModel {
            let month: Int
            let year: Int
        }
    }
    
    enum Movements {
        struct Request { }
        
        struct Response {
            let month: Int
            let year: Int
        }
        
        struct ViewModel {
            let month: Int
            let year: Int
        }
    }

    enum Modal {
        struct Request { }
        struct Response {
            let viewController: UIViewController
        }
        
        struct ViewModel {
            let viewController: UIViewController
        }
    }
}

class Account: AccountBase {
    let balance: String

    init(
        id: String,
        bankName: String,
        imageURL: String,
        accountNumber: String,
        balance: String
    ) {
        self.balance = balance
        super.init(
            id: id,
            bankName: bankName,
            imageURL: imageURL,
            accountNumber: accountNumber
        )
    }
}

class AccountBase: Equatable {
    let id: String
    let bankName: String
    let imageURL: String
    let accountNumber: String

    init(
        id: String,
        bankName: String,
        imageURL: String,
        accountNumber: String
    ) {
        self.id = id
        self.bankName = bankName
        self.imageURL = imageURL
        self.accountNumber = accountNumber
    }

    static func == (lhs: AccountBase, rhs: AccountBase) -> Bool {
        lhs.id == rhs.id
    }
}

class CreditCard: Equatable {
    let id: String
    let level: String
    let image: UIImage
    let limit: String
    let currentStatement: String
    let dueDate: String
    let bankName: String
    let bankImage: String
    let endNumber: String
    let lastClosedBill: String
    let isMainBank: Bool
    
    var isValuesHidden = false
    
    init(
        id: String,
        level: String,
        image: UIImage,
        limit: String,
        currentStatement: String,
        dueDate: String,
        bankName: String,
        bankImage: String,
        endNumber: String,
        lastClosedBill: String,
        isValuesHidden: Bool = false,
        isMainBank: Bool
    ) {
        self.id = id
        self.level = level
        self.image = image
        self.limit = limit
        self.currentStatement = currentStatement
        self.dueDate = dueDate
        self.bankName = bankName
        self.bankImage = bankImage
        self.endNumber = endNumber
        self.lastClosedBill = lastClosedBill
        self.isValuesHidden = isValuesHidden
        self.isMainBank = isMainBank
    }
    
    static func == (
        lhs: CreditCard,
        rhs: CreditCard
    ) -> Bool {
        lhs.id == rhs.id
    }
    
    func getUDSLevel() -> UDSCreditCardHeaderStyle {
        switch self.level.lowercased() {
        case "infinite":
            return .infinite
        case "infinitePearl":
            return .infinitePearl
        case "classic":
            return .classic
        case "platinum":
            return .platinum
        case "gold":
            return .gold
        case "business":
            return .business
        case "electron":
            return .electron
        case "university":
            return .university
        case "unicredVisa":
            return .unicredVisa
        case "openFinance":
            return .openFinance
        case "basic":
            return .basic
        default:
            return .neutral
        }
    }
    
    @discardableResult
    func setIsValuesHidden(to flag: Bool) -> Self {
        isValuesHidden = flag
        return self
    }
    
    @discardableResult
    func toUDS(
        delegate: UDSBalanceCreditCardViewModelDelegate? = nil
    ) -> UDSBalanceCreditCardViewModel {
        UDSBalanceCreditCardViewModel(
            delegate: delegate,
            creditCardHeader: UDSCreditCardHeaderModel(
                logo: image,
                logoTintColor: isMainBank ? .white : nil,
                name: level.capitalized,
                nameColor: isMainBank ? .white : UDSColors.grey600.color,
                dividerColor: isMainBank ? .white : UDSColors.grey600.color,
                backgroundImage: isMainBank ? UDSAssets.udsVisaProductCurves.image : UIImage(),
                backgroundGradientColor: isMainBank ? getUDSLevel() : nil
            ),
            title: I18n.currentStatement.localized,
            value: currentStatement,
            subtitle: "Fatura anterior: \(isValuesHidden ? lastClosedBill.withHiddenValues() : lastClosedBill.isEmpty ? "-" : lastClosedBill)",
            additionalInfo: UDSCreditCardAdditionalInfoViewModel(
                firstTitle: I18n.availableLimit.localized,
                firstSubtitle: limit,
                secondTitle: I18n.dueDate.localized,
                secondSubtitle: dueDate
            )
        )
    }
}

struct Insight {
    let title: String?
    let description: String
    let iconName: String
    let icon: UIImage?

    init(
        title: String?,
        description: String,
        iconName: String,
        icon: UIImage? = nil
    ) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.icon = icon
    }

    func hidden() -> Self {
        return Insight(
            title: title?.withHiddenValues(),
            description: description.withHiddenValues(),
            iconName: iconName,
            icon: icon
        )
    }
}

struct MonthSpending {
    let total: Double
    let month: String
    let year: String
    let shortMonth: String
    let shortYear: String
    let spendings: [SpendingCategory]
}

struct SpendingCategory {
    let id: String
    let title: String
    let value: String
    let icon: String
    let percentage: Double
    let color: UIColor
}

struct PFMSpendingViewModel {
    let categoryID: String
    let title: String
    let description: String
    let icon: UIImage
    let value: String
    let percentage: Double
    let showDivider: Bool
    let indicatorColor: UIColor

    func toUDS(hideValues: Bool = false, with delegate: UDSSpendingViewModelDelegate? = nil) -> UDSSpendingViewModel {
        return UDSSpendingViewModel(
            subtitle: title,
            description: hideValues ? I18n.hiddenValue.localized : description,
            icon: icon,
            value: value,
            showDivider: showDivider,
            indicatorColor: indicatorColor,
            delegate: delegate
        )
    }
    
    func toUDSSpending(hideValues: Bool = false, with delegate: UDSSpendingViewModelDelegate? = nil) -> UDSSpending {
        let view = UDSSpending()
        view.configure(
            with: toUDS(hideValues: hideValues, with: delegate)
        )
        view.accessibilityIdentifier = categoryID
        return view
    }
}

extension [PFMSpendingViewModel] {
    func toUDS(
        hideValues: Bool = false,
        with delegate: UDSSpendingViewModelDelegate? = nil
    ) -> [UDSSpendingViewModel] {
        return map {
            $0.toUDS(
                hideValues: hideValues,
                with: delegate
            )
        }
    }
    
    func toUDSSpending(
        hideValues: Bool = false,
        with delegate: UDSSpendingViewModelDelegate? = nil
    ) -> [UDSSpending] {
        return map {
            $0.toUDSSpending(
                hideValues: hideValues,
                with: delegate
            )
        }
    }
}

enum HomeSection: Int, CaseIterable {
    case expensesChart
    case infos
    case accounts
    case cards
    case expensesList
}
