//
//  MockData.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 03/04/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation
import NetworkSdk
@testable import InvestplaySDK

// swiftlint:disable all
struct MockData {
    static let link = Link(
        id: "testLink",
        createdAt: .now,
        status: .created,
        servicesStatus: .pending,
        brand: Brand(
            id: "1",
            name: "Test Bank",
            primaryColor: "FFF",
            institutionUrl: "",
            imageUrl: "", 
            isMainInstitution: true
        ),
        lastUpdateAt: .now,
        services: [serviceAccount, serviceCreditCard],
        sourceDataType: .regulatedData
    )

    static let linkList = [link]

    static let serviceAccount = Service(
        id: "1",
        linkId: "testLink",
        name: "",
        type: .account,
        status: .disabled,
        sourceDataType: .manual,
        accountData: .init(type: .bank, subtype: .checkingAccount, balance: 2500, displayNumber: "123", currencyCode: nil),
        creditCardData: nil,
        investmentSummary: nil,
        createdAt: .now,
        belongsToMainInstitution: true
    )

    static let serviceCreditCard = Service(
        id: "1",
        linkId: "testLink",
        name: "",
        type: .creditCard,
        status: .disabled,
        sourceDataType: .manual,
        accountData: nil,
        creditCardData: CreditCardData(
            balance: 600,
            displayNumber: nil,
            currencyCode: nil,
            level: "Platinum",
            brand: "Nubank",
            balanceCloseDate: nil,
            balanceCloseDay: nil,
            balanceDueDate: nil,
            balanceDueDay: nil,
            availableCreditLimit: 2500,
            _creditLimit: nil,
            previousBill: nil
        ),
        investmentSummary: nil,
        createdAt: .now,
        belongsToMainInstitution: true
    )

    static let serviceList = [serviceAccount, serviceCreditCard]

    class InsightDataMock: InsightData {
        var amount: Double = 250
        var monthIndex: MonthIndex?
        var percentage: KotlinDouble? = .init()
        var spendingsLevelColor: SpendingsLevelColor? = .green
    }

    class InsightMock: NetworkSdk.Insight {
        var data: InsightData = InsightDataMock()
        var details: String = "Details"
        var iconName: String = "Random icon"
        var insightType: InsightType = .spendingsLevel
        var title: String? = "Test Insight"
    }

    class MonthlySpendingMock: MonthlySpending {
        var allSpendingsByCategories: [any SpendingsByCategory] = []
        var amount: Double = 1500
        var monthName: String = "Dezembro"
        var spendingsByCategories: [SpendingsByCategory] = [SpendingsByCategoryMock()]
        var transactions: [NetworkSdk.Transaction] = []
        var monthIndex_: Int32 = 2
        var year: Int32 = 2024
    }

    class SpendingsByCategoryMock: SpendingsByCategory {
        var isOtherCategories: Bool = false
        var amount: Double = 200
        var category: CategoryData?
        var percentage_: Double = 20
        var transactionIds: [String] = []
    }

    class SpendingMock: Spendings {
        var currentMonth: MonthlySpending?

        var insights: [NetworkSdk.Insight] = [
            InsightMock()
        ]

        var previousMonths: [MonthlySpending] = [MonthlySpendingMock()]

        var spendingsByMonth: [MonthlySpending] = [MonthlySpendingMock()]

        var spendingsLevel: NetworkSdk.Insight?
    }

    static let spending: Spendings = SpendingMock()

    static let transaction = Transaction_(
        id: "",
        linkId: "",
        serviceId: "",
        date: .now,
        description: "",
        type: .credit,
        amount: 100,
        currencyCode: "",
        category: CategoryData(
            id: "",
            name: "",
            mainCategoryName: "",
            level: 2,
            mainCategoryId: "",
            localization: nil,
            parentCategoryId: nil,
            parentCategoryName: nil,
            iconName: nil,
            color: nil
        ),
        sourceDataType: .manual,
        ignoreSpending: nil,
        customNotes: ""
    )

    static let transactionList = [transaction]

    static let transactionWithSummary = TransactionsWithSummary(
        summary: TransactionSummary(
            from: .now,
            to: .now,
            balance: 100,
            incoming: 200,
            spending: 300
        ),
        transactions: transactionList
    )
}
// swiftlint:enable all
