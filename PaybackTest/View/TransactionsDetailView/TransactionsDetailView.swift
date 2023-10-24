//
//  TransactionsDetailView.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct TransactionsDetailView: View {
    let store: StoreOf<TransactionsDetailFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewStore.state.transaction.partnerDisplayName)
                            .bold()

                        Text(viewStore.state.transaction.transactionDetail.description ?? "")
                            .bold()
                    }
                    .padding()

                    Spacer()
                }

                Spacer()
            }
            .navigationTitle("Transaction details")
        }
    }
}
