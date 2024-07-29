//
//  ViewCode.swift
//  InvestPlay
//
//  Created by Luan Camara on 09/02/24.
//

import UIKit

protocol ViewCode: UIView {
    func buildViewHierachy()
    func addContraints()
    func addAdditionalConfiguration()
}

extension ViewCode {
    func addAdditionalConfiguration() { }
}

extension ViewCode {
    @discardableResult
    func setupView() -> Self {
        buildViewHierachy()
        addContraints()
        addAdditionalConfiguration()
        return self
    }
}
