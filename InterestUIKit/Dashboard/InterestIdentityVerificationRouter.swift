//
//  InterestIdentityVerificationRouter.swift
//  Blockchain
//
//  Created by Alex McGregor on 7/28/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import PlatformUIKit
import SafariServices

public final class InterestDashboardAnnouncementRouter: InterestDashboardAnnouncementRouting {
    
    private weak var topMostViewControllerProvider: TopMostViewControllerProviding!
    private let router: KYCRouterAPI
    private let navigationRouterAPI: NavigationRouterAPI
    
    public init(topMostViewControllerProvider: TopMostViewControllerProviding = resolve(),
                routerAPI: KYCRouterAPI = resolve(),
                navigationRouter: NavigationRouterAPI) {
        self.topMostViewControllerProvider = topMostViewControllerProvider
        self.router = routerAPI
        self.navigationRouterAPI = navigationRouter
    }
    
    public func dismiss(startKYC: Bool) {
        topMostViewControllerProvider.topMostViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            guard startKYC else { return }
            self.router.start()
        })
    }
    
    public func visitBlockchainTapped() {
        topMostViewControllerProvider.topMostViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            let controller = SFSafariViewController(url: URL(string: "https://www.blockchain.com")!)
            self.navigationRouterAPI.present(viewController: controller)
        })
    }
}
