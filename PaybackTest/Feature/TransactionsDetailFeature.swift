//
//  TransactionsDetailFeature.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import Foundation
import ComposableArchitecture

struct TransactionsDetailFeature: Reducer {
    struct State: Equatable {
        var transaction: Transaction
    }
    
    enum Action: Equatable {

    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
