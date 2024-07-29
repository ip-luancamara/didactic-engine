//
//  ContentView.swift
//  InvestplayApp
//
//  Created by Luan Câmara on 28/03/24.
//

import SwiftUI
import InvestplaySDK

struct ContentView: View {
    
    var body: some View {
        ViewControllerRepresentable {
            UINavigationController(
                rootViewController: Investplay.getPFM(environment: .debug)
            )
        }.ignoresSafeArea().task {
            Investplay.canMakeNetworkRequest = true
        }
    }
}

#Preview {
    ContentView()
}

@available(iOS 13.0, *)
public struct ViewControllerRepresentable: UIViewControllerRepresentable {

    let viewControllerBuilder: () -> UIViewController

    public init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Not needed
    }
}
