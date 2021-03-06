//
//  TargetSelectionPageModel.swift
//  TransactionUIKit
//
//  Created by Alex McGregor on 2/24/21.
//  Copyright © 2021 Blockchain Luxembourg S.A. All rights reserved.
//

import PlatformKit
import RxSwift

final class TargetSelectionPageModel {
    
    private let interactor: TargetSelectionInteractor
    private var mviModel: MviModel<TargetSelectionPageState, TargetSelectionAction>!
    
    var state: Observable<TargetSelectionPageState> {
        mviModel.state
    }
    
    init(initialState: TargetSelectionPageState = .empty, interactor: TargetSelectionInteractor) {
        self.interactor = interactor
        mviModel = MviModel(
            initialState: initialState,
            performAction: { [unowned self] (state, action) -> Disposable? in
                self.perform(previousState: state, action: action)
            }
        )
    }
    
    func destroy() {
        mviModel.destroy()
    }
    
    // MARK: - Internal methods
    
    func process(action: TargetSelectionAction) {
        mviModel.process(action: action)
    }
    
    func perform(previousState: TargetSelectionPageState, action: TargetSelectionAction) -> Disposable? {
        // TODO: Action for addres entry.
        // Validate the address on each keystroke.
        switch action {
        case .sourceAccountSelected(let account, let action):
            return processTargetListUpdate(sourceAccount: account, action: action)
        case .destinationSelected,
             .availableTargets,
             .destinationConfirmed,
             .resetFlow,
             .returnToPreviousStep:
            return nil
        }
    }
    
    private func processTargetListUpdate(sourceAccount: BlockchainAccount, action: AssetAction) -> Disposable {
        interactor
            .getAvailableTargetAccounts(sourceAccount: sourceAccount, action: action)
            .subscribe { [weak self] accounts in
                self?.process(action: .availableTargets(accounts))
            }
    }
}
