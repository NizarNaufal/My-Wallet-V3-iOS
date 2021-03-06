//
//  LinkBankFlowRootBuilder.swift
//  BuySellUIKit
//
//  Created by Dimitrios Chatzieleftheriou on 10/12/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import BuySellKit
import PlatformUIKit
import RIBs

// MARK: - Builder

public protocol LinkBankFlowRootBuildable {
    /// Builds the flow for linking a new bank
    /// - Parameter presentingController: A `NavigationControllerAPI` object that acts as a presenting controller
    func build(presentingController: NavigationControllerAPI?) -> LinkBankFlowStarter
}

public final class LinkBankFlowRootBuilder: LinkBankFlowRootBuildable {

    public init() {
    }

    public func build(presentingController: NavigationControllerAPI?) -> LinkBankFlowStarter {
        let splashScreenBuilder = LinkBankSplashScreenBuilder()
        let yodleeScreenBuilder = YodleeScreenBuilder()
        let failureScreenBuilder = LinkBankFailureScreenBuilder()
        let interactor = LinkBankFlowRootInteractor()
        return LinkBankFlowRootRouter(interactor: interactor,
                                      presentingController: presentingController,
                                      splashScreenBuilder: splashScreenBuilder,
                                      yodleeScreenBuilder: yodleeScreenBuilder,
                                      failureScreenBuilder: failureScreenBuilder)
    }
}
