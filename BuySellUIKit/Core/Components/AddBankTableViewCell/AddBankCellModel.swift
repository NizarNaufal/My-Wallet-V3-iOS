//
//  AddBankCellModel.swift
//  BuySellUIKit
//
//  Created by Dimitrios Chatzieleftheriou on 07/10/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import Localization
import PlatformKit
import PlatformUIKit
import RxDataSources

final class AddBankCellModel {

    private typealias AccessibilityId = Accessibility.Identifier.AddBankView
    private typealias LocalizedString = LocalizationConstants.Settings.Bank

    let titleLabelContent: LabelContent
    let badgeImageViewModel: BadgeImageViewModel

    let fiatCurrency: FiatCurrency

    init(fiatCurrency: FiatCurrency) {
        self.fiatCurrency = fiatCurrency

        badgeImageViewModel = .template(
            with: "icon-bank",
            templateColor: .secondary,
            backgroundColor: .clear,
            cornerRadius: .value(0),
            accessibilityIdSuffix: AccessibilityId.image
        )
        badgeImageViewModel.marginOffsetRelay.accept(0)

        titleLabelContent = LabelContent(
            text: "\(LocalizedString.addPrefix) \(fiatCurrency.code) \(LocalizedString.addSuffix)",
            font: .main(.semibold, 16),
            color: .titleText,
            accessibility: .id("\(AccessibilityId.name)\(fiatCurrency.name)")
        )
    }
}

extension AddBankCellModel: IdentifiableType {
    public var identity: String {
        fiatCurrency.name
    }
}

extension AddBankCellModel: Equatable {
    public static func == (lhs: AddBankCellModel, rhs: AddBankCellModel) -> Bool {
        lhs.fiatCurrency == rhs.fiatCurrency
    }
}

private extension Accessibility.Identifier {
    enum AddBankView {
        private static let prefix = "AddBankView."
        static let image = "\(prefix)image"
        static let name = "\(prefix)name."
    }
}
