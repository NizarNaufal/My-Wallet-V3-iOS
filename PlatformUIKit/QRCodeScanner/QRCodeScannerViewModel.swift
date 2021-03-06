//
//  QRCodeScannerViewModel.swift
//  PlatformUIKit
//
//  Created by Jack on 15/02/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import Localization
import PlatformKit

public protocol QRCodeScannerTextViewModel {
    var loadingText: String? { get }
    var headerText: String { get }
}

protocol QRCodeScannerViewModelProtocol: class {
    var scanningStarted: (() -> Void)? { get set }
    var scanningStopped: (() -> Void)? { get set }
    var closeButtonTapped: (() -> Void)? { get set }
    var scanComplete: ((Result<String, QRScannerError>) -> Void)? { get set }
    
    var videoPreviewLayer: CALayer? { get }
    var loadingText: String? { get }
    var headerText: String { get }
    var overlayViewModel: QRCodeScannerOverlayViewModel { get }
    
    func closeButtonPressed()
    func startReadingQRCode(from scannableArea: QRCodeScannableArea)
    func handleDismissCompleted(with scanResult: Result<String, QRScannerError>)
    
    func viewWillDisappear()
    func handleSelectedQRImage(_ image: UIImage)
}

public enum QRCodeScannerParsingOptions {
    
    /// Strict approach, only act on the link using the given parser
    case strict
    
    /// Lax parsing, allow acting on other routes at well
    case lax(routes: [DeepLinkRoute])
}

final class QRCodeScannerViewModel<P: QRCodeScannerParsing>: QRCodeScannerViewModelProtocol {
    
    typealias CompletionHandler = ((Result<P.Success, P.Failure>) -> Void)
    
    var scanningStarted: (() -> Void)?
    var scanningStopped: (() -> Void)?
    var closeButtonTapped: (() -> Void)?
    var scanComplete: ((Result<String, QRScannerError>) -> Void)?
    
    let overlayViewModel: QRCodeScannerOverlayViewModel
    
    var videoPreviewLayer: CALayer? {
        scanner.videoPreviewLayer
    }
    
    var loadingText: String? {
        textViewModel.loadingText
    }
    
    var headerText: String {
        textViewModel.headerText
    }
    
    private let parser: AnyQRCodeScannerParsing<P.Success, P.Failure>
    private let textViewModel: QRCodeScannerTextViewModel
    private let scanner: QRCodeScannerProtocol
    private let completed: ((Result<P.Success, P.Failure>) -> Void)
    private let deepLinkQRCodeRouter: DeepLinkQRCodeRouter
    
    init?(parser: P,
          additionalParsingOptions: QRCodeScannerParsingOptions = .strict,
          textViewModel: QRCodeScannerTextViewModel,
          scanner: QRCodeScannerProtocol,
          completed: CompletionHandler?) {
        guard let completed = completed else { return nil }
        
        let additionalLinkRoutes: [DeepLinkRoute]
        switch additionalParsingOptions {
        case .lax(routes: let routes):
            additionalLinkRoutes = routes
        case .strict:
            additionalLinkRoutes = []
        }
        self.deepLinkQRCodeRouter = DeepLinkQRCodeRouter(supportedRoutes: additionalLinkRoutes)
        self.parser = AnyQRCodeScannerParsing(parser: parser)
        self.textViewModel = textViewModel
        self.scanner = scanner
        self.completed = completed
        self.overlayViewModel = .init(supportsCameraRoll: parser is AddressQRCodeParser)
        self.scanner.delegate = self
    }
    
    func viewWillDisappear() {
        scanner.stopReadingQRCode(complete: nil)
    }
    
    func closeButtonPressed() {
        scanner.stopReadingQRCode(complete: nil)
        closeButtonTapped?()
    }
    
    func startReadingQRCode(from scannableArea: QRCodeScannableArea) {
        scanner.startReadingQRCode(from: scannableArea)
    }
    
    func handleSelectedQRImage(_ image: UIImage) {
        scanner.handleSelectedQRImage(image)
    }
    
    func handleDismissCompleted(with scanResult: Result<String, QRScannerError>) {
        
        // In case the designate scan purpose was not fulfilled, try look for supported deeplink.
        let completion = { [weak self] (result: Result<P.Success, P.Failure>) in
            guard let self = self else { return }
            switch result {
            case .failure:
                if !self.deepLinkQRCodeRouter.routeIfNeeded(using: scanResult) {
                    self.completed(result)
                }
            case .success:
                self.completed(result)
            }
        }
        parser.parse(scanResult: scanResult, completion: completion)
    }
}

extension QRCodeScannerViewModel: QRCodeScannerDelegate {
    func scanComplete(with result: Result<String, QRScannerError>) {
        scanComplete?(result)
    }
    
    func didStartScanning() {
        scanningStarted?()
    }
    
    func didStopScanning() {
        scanningStopped?()
    }
}
