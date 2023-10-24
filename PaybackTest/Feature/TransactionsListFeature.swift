//
//  TransactionsListFeature.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import Foundation
import ComposableArchitecture

struct TransactionsListFeature: Reducer {

    // MARK: - Dependencies

    @Dependency(\.transactionsService) var transactionsService

    enum LoadingState {
        case notStarted
        case loading
        case loaded
        case error
    }

    struct State: Equatable {
        var loadingState: LoadingState = .notStarted
        var transactions: IdentifiedArrayOf<Transaction> = []
        @PresentationState var alert: AlertState<Action.Alert>?
        var selectedTransaction: Transaction?
        var path = StackState<TransactionsDetailFeature.State>()
    }

    enum Action: Equatable {
        case onAppear
        case transactionsResponse(TaskResult<[Transaction]>)
        case path(StackAction<TransactionsDetailFeature.State, TransactionsDetailFeature.Action>)
        case alert(PresentationAction<Alert>)
        case sortByCategory
        case reorderToDefault
        enum Alert: Equatable {}
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.loadingState == .loaded { return .none }
                state.loadingState = .loading
                return .run { send in
                    await send(.transactionsResponse(
                        TaskResult { try await self.transactionsService.getTransactions() }
                    ))
                }
            case .transactionsResponse(.success(let items)):
                state.loadingState = .loaded
                state.transactions.append(contentsOf: items.sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate }))
                return .none
            case .transactionsResponse(.failure(let error)):
                state.loadingState = .error

                if let err = error as? TransactionsService.NetworkError {
                    state.alert = AlertState {
                        TextState("You are not connected to the internet")
                    } actions: {

                    } message: {
                        TextState(err.localizedDescription)
                    }
                } else {
                    state.alert = AlertState {
                        TextState("Error! Unable to retrieve data.")
                    } actions: {

                    } message: {
                        TextState(error.localizedDescription)
                    }
                }
                return .none
            case .path:
                return .none
            case .alert(.dismiss):
                return .none
            case .sortByCategory:
                let sorted = state.transactions.sorted(by: { $0.category > $1.category })

                state.transactions.removeAll()
                state.transactions.append(contentsOf: sorted)
                return .none
            case .reorderToDefault:
                let sorted = state.transactions.sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })

                state.transactions.removeAll()
                state.transactions.append(contentsOf: sorted)
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
        .forEach(\.path, action: /Action.path) {
            TransactionsDetailFeature()
        }
    }
}
