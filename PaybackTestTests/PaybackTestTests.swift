//
//  PaybackTestTests.swift
//  PaybackTestTests
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import ComposableArchitecture
import XCTest
@testable import PaybackTest

@MainActor
final class PaybackTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTransactionsListFeature() async {
        let uuid = UUID(uuidString: "BE3B5CC6-1C8A-45D1-9729-8FB796F52C28")!
        let date = Date(timeIntervalSinceReferenceDate: -123456789.0)
        let items = [Transaction(id: uuid, partnerDisplayName: "", alias: Alias(reference: ""), category: 1, transactionDetail: TransactionDetail(description: "", bookingDate: date, value: TransactionDetailValue(amount: 1, currency: .pbp)))]

        let store = TestStore(initialState: TransactionsListFeature.State()) {
            TransactionsListFeature()
        } withDependencies: {
            $0.transactionsService.getTransactions = { items }
        }

        await store.send(.onAppear) {
            $0.loadingState = .loading
        }

        await store.receive(.transactionsResponse(.success(items)), timeout: 2) {
            $0.loadingState = .loaded
            $0.transactions = IdentifiedArray(uniqueElements: items)
            $0.sumOfTransactions = 1
        }
    }
}
