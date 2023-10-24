//
//  PaybackTestApp.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct PaybackTestApp: App {
    var body: some Scene {
        WindowGroup {
            TransactionsView(store: Store(initialState: TransactionsListFeature.State(), reducer: {
                TransactionsListFeature()
            }))
        }
    }
}
