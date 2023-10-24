//
//  TransactionsView.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct TransactionsView: View {
    let store: StoreOf<TransactionsListFeature>

    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    if viewStore.state.loadingState == .loading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        if viewStore.state.transactions.isEmpty {
                            Text("There is no information currently available!")
                                .font(.system(size: 18, weight: .medium))
                                .multilineTextAlignment(.center)
                        } else {
                            List {
                                ForEach(viewStore.state.transactions) { transaction in
                                    NavigationLink(state: TransactionsDetailFeature.State(transaction: transaction)) {
                                        TransactionRow(transaction: transaction)
                                    }
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
                .navigationTitle("Transactions")
                .alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        } destination: { store in
            TransactionsDetailView(store: store)
        }
    }
}
