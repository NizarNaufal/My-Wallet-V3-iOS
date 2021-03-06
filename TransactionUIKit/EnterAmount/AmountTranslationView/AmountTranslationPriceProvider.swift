//
//  File.swift
//  TransactionUIKit
//
//  Created by Paulo on 14/12/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import PlatformKit
import PlatformUIKit
import RxCocoa
import RxRelay
import RxSwift
import ToolKit

final class AmountTranslationPriceProvider: AmountTranslationPriceProviding {

    private let transactionModel: TransactionModel

    init(transactionModel: TransactionModel) {
        self.transactionModel = transactionModel
    }

    func pairFromFiatInput(cryptoCurrency: CryptoCurrency, fiatCurrency: FiatCurrency, amount: String) -> Single<MoneyValuePair> {
        transactionModel
            .state
            .map(\.sourceToFiatPair)
            .filter { $0 != nil }
            .compactMap { $0 }
            .map { sourceToFiatPair -> MoneyValuePair in
                let amount = amount.isEmpty ? "0" : amount
                return MoneyValuePair(
                    fiat: FiatValue.create(major: amount, currency: fiatCurrency)!,
                    priceInFiat: sourceToFiatPair.quote.fiatValue!,
                    cryptoCurrency: cryptoCurrency,
                    usesFiatAsBase: true
                )
            }
            .take(1)
            .asSingle()
    }

    func pairFromCryptoInput(cryptoCurrency: CryptoCurrency, fiatCurrency: FiatCurrency, amount: String) -> Single<MoneyValuePair> {
        transactionModel
            .state
            .map(\.sourceToFiatPair)
            .filter { $0 != nil }
            .compactMap { $0 }
            .map { sourceToFiatPair -> MoneyValuePair in
                let amount = amount.isEmpty ? "0" : amount
                return try MoneyValuePair(
                    base: CryptoValue.create(major: amount, currency: cryptoCurrency)!.moneyValue,
                    exchangeRate: sourceToFiatPair.quote
                )
            }
            .take(1)
            .asSingle()
    }
}
