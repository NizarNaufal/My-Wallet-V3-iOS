//
//  WithdrawalCheckoutResponse.swift
//  BuySellKit
//
//  Created by Dimitrios Chatzieleftheriou on 02/11/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import PlatformKit

public struct WithdrawalAmountResponse: Decodable {
    let symbol: String
    let value: String
}

public struct WithdrawalCheckoutResponse: Decodable {
    let id: String
    let user: String
    let product: String
    let state: String
    let amount: WithdrawalAmountResponse
}
