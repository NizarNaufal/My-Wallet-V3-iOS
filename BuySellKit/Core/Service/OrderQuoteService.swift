//
//  OrderQuoteService.swift
//  PlatformKit
//
//  Created by Daniel Huri on 06/02/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import PlatformKit
import RxSwift

public protocol OrderQuoteServiceAPI: class {
    func getQuote(for action: Order.Action,
                  cryptoCurrency: CryptoCurrency,
                  fiatValue: FiatValue) -> Single<Quote>
}

final class OrderQuoteService: OrderQuoteServiceAPI {
    
    // MARK: - Properties
    
    private let client: QuoteClientAPI

    // MARK: - Setup
    
    init(client: QuoteClientAPI = resolve()) {
        self.client = client
    }
    
    // MARK: - API
    
    func getQuote(for action: Order.Action,
                  cryptoCurrency: CryptoCurrency,
                  fiatValue: FiatValue) -> Single<Quote> {
        client.getQuote(
            for: action,
            to: cryptoCurrency,
            amount: fiatValue
        )
        .map {
            try Quote(
                to: cryptoCurrency,
                amount: fiatValue,
                response: $0
            )
        }
    }
}
