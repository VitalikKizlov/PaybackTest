//
//  TransactionRow.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import Foundation
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    private let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.transactionDetail.formattedDate)
                        .bold()
                        .foregroundColor(.white)

                    Text(transaction.partnerDisplayName)
                        .bold()
                        .foregroundColor(.white)

                    Text(transaction.transactionDetail.description ?? "")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()

                Spacer()

                HStack {
                    Text("\(transaction.transactionDetail.value.amount)")
                        .bold()
                        .foregroundColor(.white)

                    Text(transaction.transactionDetail.value.currency.rawValue)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
            }
            .padding(.bottom, 10)
            .padding(.top, 10)
            .frame(width: screenWidth - 10)
            .background(Color.indigo)

        }
        .padding(.top, 4)
        .background(Color.white)
    }
}
