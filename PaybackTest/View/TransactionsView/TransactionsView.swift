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
                            ZStack {
                                List {
                                    ForEach(viewStore.state.transactions) { transaction in
                                        NavigationLink(state: TransactionsDetailFeature.State(transaction: transaction)) {
                                            TransactionRow(transaction: transaction)
                                        }
                                    }
                                }
                                .listStyle(.plain)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))

                                VStack {
                                    Spacer()

                                    HStack {
                                        Text ("Sum of filtered transactions is \(viewStore.state.sumOfTransactions)")
                                            .foregroundColor(.white)
                                    }

                                    .frame(minWidth: 100, maxWidth: .infinity, maxHeight: 50)
                                    .background(Color.gray.ignoresSafeArea())
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Transactions")
                .toolbar(content: {
                    ToolbarItem {
                        Menu {
                            Button("Sort by category") {
                                viewStore.send(.sortByCategory)
                            }
                            Button("Reorder to default") {
                                viewStore.send(.reorderToDefault)
                            }
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
                    }
                })
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
