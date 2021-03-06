//
//  ConfirmationPageDetailsPresenter.swift
//  BuySellUIKit
//
//  Created by Dimitrios Chatzieleftheriou on 29/10/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import Localization
import PlatformKit
import PlatformUIKit
import RIBs
import RxCocoa
import RxRelay
import RxSwift
import ToolKit

protocol ConfirmationPagePresentable: Presentable {
    var continueButtonTapped: Signal<Void> { get }
    func connect(action: Driver<ConfirmationPageInteractor.Action>) -> Driver<ConfirmationPageInteractor.Effects>
}

final class ConfirmationPageDetailsPresenter: DetailsScreenPresenterAPI, ConfirmationPagePresentable {
    // MARK: - Navigation Properties

    let reloadRelay = PublishRelay<Void>()
    let titleViewRelay = BehaviorRelay<Screen.Style.TitleView>(value: .none)
    let navigationBarLeadingButtonAction: DetailsScreen.BarButtonAction
    let navigationBarTrailingButtonAction: DetailsScreen.BarButtonAction

    var navigationBarAppearance: DetailsScreen.NavigationBarAppearance {
        .custom(
            leading: .back,
            trailing: .none,
            barStyle: .darkContent(ignoresStatusBar: false, background: .white)
        )
    }

    // MARK: - Actions
    var continueButtonTapped: Signal<Void> {
        contentReducer
            .continueButtonViewModel
            .tap
    }

    // MARK: - Screen Properties

    private(set) var buttons: [ButtonViewModel] = []
    private(set) var cells: [DetailsScreen.CellType] = []

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let navigationCloseRelay = PublishRelay<Void>()
    private let backButtonPressed = PublishRelay<Void>()
    private let continueButtonPressed = PublishRelay<Void>()

    private let contentReducer = ConfirmationPageContentReducer()

    // MARK: - Injected

    private let analyticsRecorder: AnalyticsEventRecorderAPI

    init(analyticsRecorder: AnalyticsEventRecorderAPI = resolve()) {
        self.analyticsRecorder = analyticsRecorder

        navigationBarTrailingButtonAction = .default
        navigationBarLeadingButtonAction = .custom { [backButtonPressed] in
            backButtonPressed.accept(())
        }

        buttons = [
            contentReducer.cancelButtonViewModel,
            contentReducer.continueButtonViewModel
        ]
    }

    func connect(action: Driver<ConfirmationPageInteractor.Action>) -> Driver<ConfirmationPageInteractor.Effects> {
        let details = action
            .distinctUntilChanged()
            .flatMap { (action) -> Driver<TransactionState> in
                switch action {
                case .empty:
                    return .empty()
                case .load(let data):
                    return .just(data)
                }
            }

        details.map(\.nextEnabled)
            .drive(contentReducer.continueButtonViewModel.isEnabledRelay)
            .disposed(by: disposeBag)

        details
            .drive(weak: self, onNext: { (self, state) in
                self.setup(state: state)
            })
            .disposed(by: disposeBag)

        let closeTapped = contentReducer
            .cancelButtonViewModel
            .tap
            .asObservable()
            .map { ConfirmationPageInteractor.Effects.close }
            .asDriverCatchError()

        let backTapped = backButtonPressed
            .map { ConfirmationPageInteractor.Effects.back }
            .asDriverCatchError()

        return .merge(closeTapped, backTapped)
    }

    private func setup(state: TransactionState) {

        contentReducer.setup(for: state)

        titleViewRelay.accept(.text(value: contentReducer.title))

        cells = contentReducer.cells

        reloadRelay.accept(())
    }
}
