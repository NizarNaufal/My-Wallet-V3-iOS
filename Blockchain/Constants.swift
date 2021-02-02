//
//  Constants.swift
//  Blockchain
//
//  Created by Mark Pfluger on 6/26/15.
//  Copyright (c) 2015 Blockchain Luxembourg S.A. All rights reserved.
//

import PlatformKit

struct Constants {
    
    static let commitHash = "COMMIT_HASH"

    struct Conversions {
        // SATOSHI = 1e8 (100,000,000)
        static let satoshi = Double(1e8)

        /// Stroop is a measurement of 1/10,000,000th of an XLM
        static let stroopsInXlm = Int(1e7)
    }

    struct AppStore {
        static let AppID = "id493253309"
    }
    struct Animation {
        static let duration = 0.2
        static let durationLong = 0.5
    }
    struct Navigation {
        static let tabTransactions = 0
        static let tabSwap = 1
        static let tabDashboard = 2
        static let tabSend = 3
        static let tabReceive = 4
    }
    struct Measurements {
        static let DefaultHeaderHeight: CGFloat = 65
        // TODO: remove this once we use autolayout
        static let DefaultStatusBarHeight: CGFloat = 20.0
        static let DefaultNavigationBarHeight: CGFloat = 44.0
        static let DefaultTabBarHeight: CGFloat = 49.0
        static let AssetSelectorHeight: CGFloat = 36.0
        static let BackupButtonCornerRadius: CGFloat = 4.0

        static let ScreenHeightIphone4S: CGFloat = 480.0
        static let ScreenHeightIphone5S: CGFloat = 568.0

        static let MinimumTapTargetSize: CGFloat = 22.0

        static let buttonHeight: CGFloat = 40.0
        static let buttonHeightLarge: CGFloat = 56.0
        static let buttonCornerRadius: CGFloat = 4.0
        static let assetTypeCellHeight: CGFloat = 44.0
    }
    struct FontSizes {
        static let Tiny: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 11.0 : 10.0
        static let ExtraExtraExtraSmall: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 13.0 : 11.0
        static let ExtraExtraSmall: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 14.0 : 11.0
        static let ExtraSmall: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 15.0 : 12.0
        static let Small: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 16.0 : 13.0
        static let SmallMedium: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 17.0 : 14.0
        static let Medium: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 18.0 : 15.0
        static let MediumLarge: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 19.0 : 16.0
        static let Large: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 20.0 : 17.0
        static let ExtraLarge: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 21.0 : 18.0
        static let ExtraExtraLarge: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 23.0 : 20.0
        static let Huge: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 25.0 : 22.0
        static let Gigantic: CGFloat = Booleans.IsUsingScreenSizeLargerThan5s ? 48.0 : 45.0
    }
    struct FontNames {
        static let montserratRegular = "Montserrat-Regular"
        static let montserratSemiBold = "Montserrat-SemiBold"
        static let montserratLight = "Montserrat-Light"
        static let montserratMedium = "Montserrat-Medium"
    }
    struct Defaults {
        static let NumberOfRecoveryPhraseWords = 12
    }
    struct Booleans {
        static let isUsingScreenSizeEqualIphone5S = UIScreen.main.bounds.size.height == Measurements.ScreenHeightIphone5S
        static let IsUsingScreenSizeLargerThan5s = UIScreen.main.bounds.size.height > Measurements.ScreenHeightIphone5S
    }
    struct NotificationKeys {
        static let modalViewDismissed = NSNotification.Name("modalViewDismissed")
        static let reloadToDismissViews = NSNotification.Name("reloadToDismissViews")
        static let newAddress = NSNotification.Name("newAddress")
        static let multiAddressResponseReload = NSNotification.Name("multiaddressResponseReload")
        static let appEnteredBackground = NSNotification.Name("applicationDidEnterBackground")
        static let backupSuccess = NSNotification.Name("backupSuccess")
        static let getFiatAtTime = NSNotification.Name("getFiatAtTime")
        static let exchangeSubmitted = NSNotification.Name("exchangeSubmitted")
        static let transactionReceived = NSNotification.Name("transactionReceived")
        static let kycStopped = NSNotification.Name("kycStopped")
        static let swapFlowCompleted = NSNotification.Name("swapFlowCompleted")
        static let swapToPaxFlowCompleted = NSNotification.Name("swapToPaxFlowCompleted")
    }
    struct PushNotificationKeys {
        static let userInfoType = "type"
        static let userInfoId = "id"
        static let typePayment = "payment"
    }
    struct Url {
        static let withdrawalLockArticle = "https://support.blockchain.com/hc/en-us/articles/360048200392"
        static let blockchainHome = "https://www.blockchain.com"
        static let privacyPolicy = blockchainHome + "/privacy"
        static let cookiesPolicy = blockchainHome + "/legal/cookies"
        static let termsOfService = blockchainHome + "/terms"
        static let simpleBuyGBPTerms = "https://exchange.blockchain.com/legal#modulr"

        static let appStoreLinkPrefix = "itms-apps://itunes.apple.com/app/"
        static let blockchainSupport = "https://support.blockchain.com"
        static let exchangeSupport = "https://exchange-support.blockchain.com/hc/en-us"
        static let verificationRejectedURL = "https://support.blockchain.com/hc/en-us/articles/360018080352-Why-has-my-ID-submission-been-rejected-"
        static let blockchainSupportRequest = blockchainSupport + "/hc/en-us/requests/new?"
        static let supportTicketBuySellExchange = blockchainSupportRequest + "ticket_form_id=360000014686"
        static let forgotPassword = "https://support.blockchain.com/hc/en-us/articles/211205343-I-forgot-my-password-What-can-you-do-to-help-"
        static let blockchainWalletLogin = "https://login.blockchain.com"
        static let lockbox = "https://blockchain.com/lockbox"
        static let stellarMinimumBalanceInfo = "https://www.stellar.org/developers/guides/concepts/fees.html#minimum-account-balance"
        static let airdropProgram = "https://support.blockchain.com/hc/en-us/categories/360001126692-Airdrop-Program"
        static let blockstackAirdropLearnMore = "https://support.blockchain.com/hc/en-us/articles/360035793932"
        static let airdropWaitlist = blockchainHome + "/getcrypto"
        static let requiredIdentityVerificationURL = "https://support.blockchain.com/hc/en-us/articles/360018359871-What-Blockchain-products-require-identity-verification-"
        static let learnMoreAboutPaxURL = "https://support.blockchain.com/hc/en-us/sections/360004368351-USD-Pax-FAQ"
        static let ethGasExplanationForPax = "https://support.blockchain.com/hc/en-us/articles/360027492092-Why-do-I-need-ETH-to-send-my-PAX-"
    }
    struct Wallet {
        static let swipeToReceiveAddressCount = 5
    }
    struct JSErrors {
        static let addressAndKeyImportWrongBipPass = "wrongBipPass"
        static let addressAndKeyImportWrongPrivateKey = "wrongPrivateKey"
    }
    struct FilterIndexes {
        static let all: Int32 = -1
        static let importedAddresses: Int32 = -2
    }
}

/// Constant class wrapper so that Constants can be accessed from Obj-C. Should deprecate this
/// once Obj-C is no longer using this
@objc class ConstantsObjcBridge: NSObject {
    @objc class func notificationKeyReloadToDismissViews() -> String {
        Constants.NotificationKeys.reloadToDismissViews.rawValue
    }

    @objc class func notificationKeyNewAddress() -> String {
        Constants.NotificationKeys.newAddress.rawValue
    }

    @objc class func notificationKeyMultiAddressResponseReload() -> String {
        Constants.NotificationKeys.multiAddressResponseReload.rawValue
    }

    @objc class func notificationKeyBackupSuccess() -> String {
        Constants.NotificationKeys.backupSuccess.rawValue
    }
    
    @objc class func notificationKeyTransactionReceived() -> String {
        Constants.NotificationKeys.transactionReceived.rawValue
    }
    
    @objc class func tabSwap() -> Int {
        Constants.Navigation.tabSwap
    }

    @objc class func tabSend() -> Int {
        Constants.Navigation.tabSend
    }

    @objc class func tabDashboard() -> Int {
        Constants.Navigation.tabDashboard
    }

    @objc class func tabReceive() -> Int {
        Constants.Navigation.tabReceive
    }

    @objc class func tabTransactions() -> Int {
        Constants.Navigation.tabTransactions
    }

    @objc class func filterIndexAll() -> Int32 {
        Constants.FilterIndexes.all
    }

    @objc class func filterIndexImportedAddresses() -> Int32 {
        Constants.FilterIndexes.importedAddresses
    }

    @objc class func assetTypeCellHeight() -> CGFloat {
        Constants.Measurements.assetTypeCellHeight
    }

    @objc class func bitcoinCashUriPrefix() -> String {
        AssetConstants.URLSchemes.bitcoinCash
    }

    @objc class func defaultNavigationBarHeight() -> CGFloat {
        Constants.Measurements.DefaultNavigationBarHeight
    }

    @objc class func assetSelectorHeight() -> CGFloat {
        Constants.Measurements.AssetSelectorHeight
    }

    @objc class func montserratLight() -> String {
        Constants.FontNames.montserratLight
    }

    @objc class func montserratSemiBold() -> String {
        Constants.FontNames.montserratSemiBold
    }
}
