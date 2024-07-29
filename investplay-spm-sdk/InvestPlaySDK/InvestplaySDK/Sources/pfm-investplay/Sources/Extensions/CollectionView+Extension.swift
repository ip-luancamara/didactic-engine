//
//  CollectionView+Extension.swift
//  
//
//  Created by Luan Camara on 11/11/22.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(of: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath)
        guard let cell = cell as? T else { fatalError("Cell not registered with identifier: \(T.self)") }
        return cell
    }

    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: "\(type)")
    }
}
