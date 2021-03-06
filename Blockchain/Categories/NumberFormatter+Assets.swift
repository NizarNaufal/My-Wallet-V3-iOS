//
//  NumberFormatter+Assets.swift
//  Blockchain
//
//  Created by kevinwu on 5/2/18.
//  Copyright © 2018 Blockchain Luxembourg S.A. All rights reserved.
//

import Foundation
import PlatformKit
import ToolKit

@objc
extension NumberFormatter {

    // MARK: Helper functions
    static func decimalStyleFormatter(
        withMinfractionDigits minfractionDigits: Int,
        maxfractionDigits: Int,
        usesGroupingSeparator: Bool
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.minimumFractionDigits = minfractionDigits
        formatter.maximumFractionDigits = maxfractionDigits
        formatter.roundingMode = .down
        return formatter
    }

    // MARK: Local Currency
    static let localCurrencyFractionDigits: Int = 2

    // Example: 1234.12
    static let localCurrencyFormatter: NumberFormatter = {
        decimalStyleFormatter(withMinfractionDigits: localCurrencyFractionDigits,
                                     maxfractionDigits: localCurrencyFractionDigits,
                                     usesGroupingSeparator: false)
    }()

    // Example: 1,234.12
    static let localCurrencyFormatterWithGroupingSeparator: NumberFormatter = {
        decimalStyleFormatter(withMinfractionDigits: localCurrencyFractionDigits,
                                     maxfractionDigits: localCurrencyFractionDigits,
                                     usesGroupingSeparator: true)
    }()

    // Used to create QR code string from amount
    static let localCurrencyFormatterWithUSLocale: NumberFormatter = {
        let formatter = decimalStyleFormatter(withMinfractionDigits: localCurrencyFractionDigits,
                                              maxfractionDigits: localCurrencyFractionDigits,
                                              usesGroupingSeparator: false)
        formatter.locale = Locale.US
        return formatter
    }()

    // Example: 1234.12345678
    static let assetFormatter: NumberFormatter = {
        decimalStyleFormatter(withMinfractionDigits: 0,
                              maxfractionDigits: CryptoCurrency.maxDisplayableDecimalPlaces,
                              usesGroupingSeparator: false)
    }()

    // TODO: genericize
    static let stellarFormatter: NumberFormatter = {
        decimalStyleFormatter(withMinfractionDigits: 0,
                              maxfractionDigits: CryptoCurrency.stellar.maxDisplayableDecimalPlaces,
                              usesGroupingSeparator: false)
    }()

    // Example: 1,234.12345678
    static let assetFormatterWithGroupingSeparator: NumberFormatter = {
        decimalStyleFormatter(withMinfractionDigits: 0,
                              maxfractionDigits: CryptoCurrency.maxDisplayableDecimalPlaces,
                              usesGroupingSeparator: true)
    }()

    // Used to create QR code string from amount
    // Used to convert values from returned from APIs
    static let assetFormatterWithUSLocale: NumberFormatter = {
        let formatter = decimalStyleFormatter(withMinfractionDigits: 0,
                                              maxfractionDigits: CryptoCurrency.maxDisplayableDecimalPlaces,
                                              usesGroupingSeparator: false)
        formatter.locale = .US
        return formatter
    }()
}

// MARK: - Conversions
extension NumberFormatter {
    // Returns local currency amount with two decimal places (assuming stringFromNumber returns a string)
    static func localCurrencyAmount(fromAmount: Decimal, fiatPerAmount: Decimal) -> String {
        let conversionResult = fromAmount * fiatPerAmount
        let formatter = NumberFormatter.localCurrencyFormatter
        return formatter.string(from: NSDecimalNumber(decimal: conversionResult)) ?? "\(conversionResult)"
    }

    // Returns asset type amount with correct number of decimal places (currently 7 or 8 depending on asset type) (assuming stringFromNumber returns a string)
    @objc static func assetTypeAmount(
        fromAmount: Decimal,
        fiatPerAmount: Decimal,
        assetType: LegacyCryptoCurrency
    ) -> String {
        let conversionResult = fromAmount / fiatPerAmount
        let formatter = assetType.value == .stellar ? NumberFormatter.stellarFormatter : NumberFormatter.assetFormatter
        return formatter.string(from: NSDecimalNumber(decimal: conversionResult)) ?? "\(conversionResult)"
    }

    // Returns crypto with fiat amount in the format of
    // crypto (fiat)
    static func formattedAssetAndFiatAmountWithSymbols(
        fromAmount: Decimal,
        fiatPerAmount: Decimal,
        assetType: CryptoCurrency
    ) -> String {
        let formatter = assetType == .stellar ? NumberFormatter.stellarFormatter : NumberFormatter.assetFormatter
        let crypto = (formatter.string(from: NSDecimalNumber(decimal: fromAmount)) ?? "\(fromAmount)").appendAssetSymbol(for: assetType)
        let fiat = NumberFormatter.localCurrencyAmount(fromAmount: fromAmount, fiatPerAmount: fiatPerAmount).appendCurrencySymbol()
        return "\(crypto) (\(fiat))"
    }
}
