//
//  InvestplaySDK.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 28/03/24.
//

import Foundation
import UIKit
import SwiftUI
import NetworkSdk

// swiftlint:disable identifier_name

// Enforce the minimum Swift version for all platforms and build systems.
// Note that you can use whichever version you like, or not implement this at all.
#if swift(<5.4)
    #error("InvestplaySDK doesn't support Swift versions below 5.4.")
#endif

/// Reference to `InvestplaySDK.default` for quick bootstrapping
public let Investplay = InvestplaySDKInstance.default

/// Main class to interact with the SDK.
public class InvestplaySDKInstance: InvestplaySDKAuthProvider {
    
    /// Shared singleton instance.
    static let `default` = InvestplaySDKInstance()
    
    /// InvestplaySDKInstance client ID.
    public var clientID: String?
    
    /// InvestplaySDKInstance token.
    public var token: String?
    
    public var canMakeNetworkRequest: Bool = false {
        didSet {
            logger.log("canMakeNetworkRequest set to: \(canMakeNetworkRequest)")
            guard canMakeNetworkRequest else { return }
            
            do {
                let json = try RestApiSettingsData.Factory().getUnicredBuilder(
                    baseUrl: environment.url
                ).withToken(
                    token: token ?? "8ea31759-29fb-4141-9ea3-luan"
                ).withClientId(
                    clientId: clientID ?? "8ea31759-29fb-4141-9ea3-luan"
                ).build().getJson()
                
                Preferences.KEYS_APPLICATION.restApiSettings.set(value: json)
                
                starterViewController.canMakeNetworkRequest = canMakeNetworkRequest
            } catch {
                logger.log("Failure setting restApiSettings")
                feedbackDelegate?.displayError()
            }
        }
    }

    /// Delegate to handle actions from the SDK.
    public weak var delegate: InvestplaySDKActionDelegate?
    
    /// Feedback delegate to handle feedback from the SDK.
    public weak var feedbackDelegate: InvestplaySDKFeedbackDelegate?
    
    /// Open Finance delegate to handle feedback from the SDK.
    public weak var openFinanceDelegate: InvestplaySDKOpenFinanceDelegate?
    
    private var starterViewController: PFMViewController!
    
    private var environment: Environment = .production
    
    private var logger = PFMLogger(className: InvestplaySDKInstance.self)
    
    internal init() {  /*Prevent  developers from creating their own instances by making the initializer `private`.*/ }
}

// MARK: - Public developer APIs

public protocol PFMClientIDResponse: Decodable {
    var clientID: String? { get }
    var hash: String? { get }
    var hasConsent: Bool? { get }
}

public enum Environment {
    case debug
    case homolog
    case production
    
    public var url: String {
        switch self {
        case .debug:
            "https://api.pfm-sdk.investplay-pfm-unicred-hml.click/public/v1/"
        case .homolog:
            "https://api.pfm-sdk.investplay-pfm-unicred-hml.click/public/v1/"
        case .production:
            "https://api.pfm-sdk.investplay-pfm-unicred-prd.click/public/v1/"
        }
    }
}

public extension InvestplaySDKInstance {
    /// Get the PFM View Controller.
    /// - Parameter token: current user's token.
    /// - Returns: PFM View Controller.
    func getPFM(
        environment: Environment = .production
    ) -> UIViewController {
        self.environment = environment
        starterViewController = PFMViewController()
        return starterViewController
    }
    
    func getMockedPFM() -> UIViewController {
        let viewController = PFMViewController()
        
        let json = try? RestApiSettingsData.Factory().getUnicredBuilder(
            baseUrl: "https://api.pfm-sdk.investplay-pfm-unicred-hml.click/public/v1/"
        ).withToken(
            token: "8ea31759-29fb-4141-9ea3-luan"
        ).withClientId(
            clientId: "8ea31759-29fb-4141-9ea3-luan"
        ).build().getJson()
        
        Preferences.KEYS_APPLICATION.restApiSettings.set(value: json)
        
        return viewController
    }
}

/// Screen enum to identify the current screen.
public enum InvestplaySDKScreen {
    case financialManager
    case myExpenses
    case accountDetails
    case cardDetails
    case movements
}

/// Protocol to handle the user's token and client id.
public protocol InvestplaySDKAuthProvider: AnyObject {
    var token: String? { get }
    var clientID: String? { get }
}

/// Protocol to handle the SDK actions.
public protocol InvestplaySDKActionDelegate: AnyObject {
    func didTapRightButton(on screen: InvestplaySDKScreen)
    func goToMainScreen()
}

public protocol InvestplaySDKFeedbackDelegate: AnyObject {
    func displayError()
}

public protocol InvestplaySDKOpenFinanceDelegate: AnyObject {
    func didTapBringData()
}
