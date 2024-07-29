//
//  NotificationCenterSpy.swift
//  InvestplaySDKTests
//
//  Created by Luan Câmara on 16/07/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation

class NotificationCenterSpy: NotificationCenter {
    
    var wasAddObserverCalled = false
    var wasRemoveObserverCalled = false
    
    var addObserverCompletionHandler: ((
        _ observer: Any,
        _ aSelector: Selector,
        _ aName: NSNotification.Name?,
        _ anObject: Any?
    ) -> Void)?
    
    var removeObserverCompletionHandler: ((
        _ observer: Any,
        _ aName: NSNotification.Name?,
        _ anObject: Any?
    ) -> Void)?
    
    override func addObserver(
        _ observer: Any,
        selector aSelector: Selector,
        name aName: NSNotification.Name?,
        object anObject: Any?
    ) {
        wasAddObserverCalled = true
        addObserverCompletionHandler?(
            observer,
            aSelector,
            aName,
            anObject
        )
    }
 
    override func removeObserver(
        _ observer: Any,
        name aName: NSNotification.Name?,
        object anObject: Any?
    ) {
        wasRemoveObserverCalled = true
        removeObserverCompletionHandler?(
            observer,
            aName,
            anObject
        )
    }
}
