import Foundation

private class BundleFinder {}

enum I18n: String {
    case availableLimit
    case checkingAccount
    case currentStatement
    case dueDate
    case financialManager
    case myCards
    case myAccounts
    case myExpenses
    case openStatements
    case total
    case totalBalance
    case uncategorized
    case mainViewInfoTitle
    case mainViewInfoSubtitle
    case filter
    case cleanFilter
    case accountDetails
    case cardDetails
    case monthBalance
    case entries
    case exits
    case movimentationType
    case hiddenValue
    case allTransactions
    case movements
    case totalOnPeriod
    case accessAll
    case myOutgoings
    case goToMainScreen
    case bringMyData
    case tryAgain
    case feedbackFirstLoadTitle
    case feedbackNotSharedDataTitle
    case feedbackFirstLoadDescription
    case feedbackNotSharedDataDescription
    case feedbackUnknownDescription
    case goBackToMainScreen
    case monthSelect
    case yearSelect
    case movementTypeFilterTitle
    case account
    case category
    case categoryChangeSuccessMessage
    
    case noMovementsAlertTitle
    case noMovementsAlertDescription
    
    case entry
    case exit
    case value
    case change
    
    case switchViewTitle
    case switchViewSubtitle
    
    case transactionDetails
    
    case changeCategory
    case changeCategoryScreenTitle
    case currentCategory
    
    case changeCategoryErrorAlertDescription
    case changeCategoryErrorAlertTitle
    
    case totalSpentOnCategory
    
    case emptySpendingByCategoryTitle
    case emptySpendingByCategorySubtitle
    
    private var bundle: Bundle {
        Bundle(for: BundleFinder.self)
    }

    var localized: String {
        if #available(iOS 15, *) {
            return String(localized: String.LocalizationValue(rawValue), bundle: bundle)
        }

        return NSLocalizedString(rawValue, bundle: bundle, comment: "")
    }
}
