//
//  WithdrawAmountValidationService.swift
//  BuySellUIKit
//
//  Created by Dimitrios Chatzieleftheriou on 12/10/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import BuySellKit
import DIKit
import PlatformKit
import PlatformUIKit
import RxCocoa
import RxSwift

struct ValidatedData {
    let currency: FiatCurrency
    let beneficiary: Beneficiary
    let amount: FiatValue
}

final class WithdrawAmountValidationService {

    enum Input {
        case amount(MoneyValue)
        case withdrawMax
        case empty
    }

    enum State {
        case valid(data: ValidatedData)
        case maxLimitExceeded(MoneyValue)
        case empty

        var isValid: Bool {
            switch self {
            case .valid:
                return true
            default:
                return false
            }
        }

        var isEmpty: Bool {
            switch self {
            case .empty:
                return true
            default:
                return false
            }
        }
    }

    let balance: Single<MoneyValue>
    let account: Observable<SingleAccount>

    // MARK: - Services

    private let coincore: Coincore

    // MARK: - Properties
    private let fiatCurrency: FiatCurrency
    private let beneficiary: Beneficiary

    init(fiatCurrency: FiatCurrency,
         beneficiary: Beneficiary,
         coincore: Coincore = resolve()) {
        self.fiatCurrency = fiatCurrency
        self.beneficiary = beneficiary
        self.coincore = coincore

        self.account = coincore.allAccounts
            .compactMap { [fiatCurrency] group in
                group.accounts.first(where: { $0.currencyType == fiatCurrency.currency })
            }
            .asObservable()
            .share(replay: 1, scope: .whileConnected)

        self.balance = account
            .asObservable()
            .flatMap { account -> Single<MoneyValue> in
                account.balance
            }
            .asSingle()

    }

    func connect(inputs: Observable<Input>) -> Observable<State> {
        inputs
            .flatMap { action -> Observable<State> in
                self.balance.map { (balance) -> State in
                    switch action {
                    case .withdrawMax:
                        guard !balance.isZero else { return .empty }
                        guard let fiatValue = balance.fiatValue else { return .empty }
                        return .valid(data: self.data(from: fiatValue))
                    case .amount(let value):
                        guard !value.isZero else { return .empty }
                        guard let fiatValue = value.fiatValue else { return .empty }
                        guard try value <= balance.value else {
                            return .maxLimitExceeded(balance.value)
                        }
                        return .valid(data: self.data(from: fiatValue))
                    default:
                        return .empty
                    }
                }
                .asObservable()
            }
    }

    private func data(from amount: FiatValue) -> ValidatedData {
        ValidatedData(
            currency: fiatCurrency,
            beneficiary: beneficiary,
            amount: amount
        )
    }

}

extension WithdrawAmountValidationService.State {

    var data: ValidatedData? {
        switch self {
        case .valid(let data):
            return data
        default:
            return nil
        }
    }

    var toAmountInteractorState: SingleAmountInteractor.State {
        switch self {
        case .empty:
            return .empty
        case .maxLimitExceeded(let value):
            return .overMaxLimit(value)
        case .valid:
            return .inBounds
        }
    }
}
