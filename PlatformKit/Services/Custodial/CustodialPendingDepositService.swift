//
//  CustodialPendingDepositService.swift
//  PlatformKit
//
//  Created by Paulo on 11/12/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import NetworkKit
import RxSwift
import ToolKit

struct CreatePendingDepositRequestBody: Encodable {
    let currency: String
    let amount: String
    let depositAddress: String
    let txHash: String
    let product: String

    init(value: MoneyValue,
         destination: String,
         transactionHash: String,
         product: String) {
        currency = value.currencyCode
        amount = value.value.amount.description
        depositAddress = destination
        txHash = transactionHash
        self.product = product
    }
}

protocol CustodialPendingDepositClientAPI: AnyObject {
    func createPendingDeposit(body: CreatePendingDepositRequestBody) -> Completable
}

public protocol CustodialPendingDepositServiceAPI: AnyObject {

    func createPendingDeposit(value: MoneyValue,
                              destination: String,
                              transactionHash: String,
                              product: String) -> Completable
}

final class CustodialPendingDepositService: CustodialPendingDepositServiceAPI {

    private let client: CustodialPendingDepositClientAPI

    // MARK: - Setup

    init(client: CustodialPendingDepositClientAPI = resolve()) {
        self.client = client
    }

    func createPendingDeposit(value: MoneyValue,
                              destination: String,
                              transactionHash: String,
                              product: String) -> Completable {
        let body = CreatePendingDepositRequestBody(
            value: value,
            destination: destination,
            transactionHash: transactionHash,
            product: product
        )
        return client.createPendingDeposit(body: body)
    }
}
