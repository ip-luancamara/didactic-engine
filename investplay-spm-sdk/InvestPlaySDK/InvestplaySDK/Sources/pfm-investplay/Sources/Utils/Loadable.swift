//
//  Loadable.swift
//  InvestplaySDK
//
//  Created by Luan Câmara on 04/06/24.
//  Copyright © 2024 Investplay. All rights reserved.
//

import Foundation

protocol Loadable {
    var isLoading: Bool { get set }
    func showLoading()
    func hideLoading()
}
