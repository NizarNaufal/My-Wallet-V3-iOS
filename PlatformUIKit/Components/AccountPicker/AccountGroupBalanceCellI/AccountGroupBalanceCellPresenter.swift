//
//  WalletBalanceCellPresenter.swift
//  Blockchain
//
//  Created by Alex McGregor on 5/5/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import Localization
import PlatformKit
import RxCocoa
import RxSwift

final class AccountGroupBalanceCellPresenter {
    
    typealias AccessibilityId = Accessibility.Identifier.Activity.WalletBalance
    
    // MARK: - Properties
    
    /// Returns the `Description`
    var description: Driver<LabelContent> {
        Driver.just(
            LabelContent.init(
                text: LocalizationConstants.Dashboard.Balance.totalBalance,
                font: .main(.medium, 14.0),
                color: .descriptionText,
                alignment: .left,
                accessibility: .id(AccessibilityId.description)
            )
        )
    }
    
    /// Returns the `Title`
    var title: Driver<LabelContent> {
        Driver.just(
            LabelContent.init(
                text: account.label,
                font: .main(.semibold, 16.0),
                color: .titleText,
                alignment: .left,
                accessibility: .id(AccessibilityId.title)
            )
        )
    }
    
    let accessibility: Accessibility = .id(AccessibilityId.cell)
    let badgeImageViewModel: BadgeImageViewModel
    let walletBalanceViewPresenter: WalletBalanceViewPresenter
    
    // MARK: - Private Properties

    private let account: AccountGroup
    private let interactor: AccountGroupBalanceCellInteractor
    private let imageViewVisibilityRelay = BehaviorRelay<Visibility>(value: .hidden)
    
    init(account: AccountGroup, interactor: AccountGroupBalanceCellInteractor) {
        self.account = account
        self.interactor = interactor
        self.walletBalanceViewPresenter = WalletBalanceViewPresenter(
            interactor: interactor.balanceViewInteractor
        )
        
        self.badgeImageViewModel = .primary(
            with: "icon-card",
            cornerRadius: .round,
            accessibilityIdSuffix: "walletBalance"
        )
        self.badgeImageViewModel.marginOffsetRelay.accept(0)
    }
}
