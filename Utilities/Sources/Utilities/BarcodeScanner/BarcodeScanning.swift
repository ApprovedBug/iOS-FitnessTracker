//
//  BarcodeScanning.swift
//  Utilities
//
//  Created by Jack Moseley on 09/11/2024.
//

import Combine
import Foundation
import OSLog
import SwiftUI
import VisionKit

public enum ScanningError: Error {
    case scannerNotAvailable
}

public protocol BarcodeScanning: Sendable {
    
    func scanner() async throws -> any View
    func startScanning() async throws
    func stopScanning() async
    
    @MainActor var barcodes: PassthroughSubject<String, Never> { get }
}

@MainActor public final class BarcodeScanner: BarcodeScanning {
    
    public let barcodes: PassthroughSubject<String, Never> = .init()
    
    private var dataScannerView: BarcodeScannerRepresentable?
    
    public init() {}
    
    public func scanner() throws -> any View  {
        guard DataScannerViewController.isSupported && DataScannerViewController.isAvailable else {
            throw ScanningError.scannerNotAvailable
        }
        
        let view = BarcodeScannerRepresentable(barcodes: barcodes)
        dataScannerView = view
        return view
    }
    
    public func startScanning() async {
        dataScannerView?.startScanning()
    }
    
    public func stopScanning() async {
        dataScannerView?.stopScanning()
    }
}

let logger = Logger(subsystem: "com.approvedbug.FitnessTracker", category: "BarcodeScanning")

private struct BarcodeScannerRepresentable: UIViewControllerRepresentable {
    
    let barcodes: PassthroughSubject<String, Never>
    
    private let coordinator: Coordinator
    
    typealias UIViewControllerType = DataScannerViewController
    
    init(barcodes: PassthroughSubject<String, Never>) {
        self.barcodes = barcodes
        self.coordinator = Coordinator(barcodes: barcodes)
    }
    
    func makeCoordinator() -> Coordinator {
        coordinator
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        // open barcode scanner and publish data to public passthrough subject
        let dataScannerViewController = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: true
        )
        
        context.coordinator.dataScannerViewController = dataScannerViewController
        dataScannerViewController.delegate = context.coordinator
        
        // Add gradient and close button
        addGradientView(to: dataScannerViewController)
        addCloseButton(to: dataScannerViewController, context: context)
        addScannerView(to: dataScannerViewController)
        
        return dataScannerViewController
    }
    
    // Adds gradient shadow view at the top of the screen
    private func addGradientView(to dataScannerViewController: DataScannerViewController) {
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        dataScannerViewController.view.addSubview(gradientView)
        
        // Create the gradient layer and apply it to the gradientView
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the gradient layer's frame manually to match screen width
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        
        // Add the gradient layer to the gradient view
        gradientView.layer.addSublayer(gradientLayer)
        
        // Constraints to position the gradient view at the top
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: dataScannerViewController.view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: dataScannerViewController.view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: dataScannerViewController.view.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // Adds a close button in the top-right corner
    private func addCloseButton(to dataScannerViewController: DataScannerViewController, context: Context) {
        let closeButton = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark",
                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.imagePadding = 4
        closeButton.tintColor = .white
        closeButton.configuration = config
        closeButton.addTarget(context.coordinator, action: #selector(Coordinator.closeButtonTapped), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        dataScannerViewController.view.addSubview(closeButton)
        
        // Add constraints to position it in the top-right corner
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: dataScannerViewController.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: dataScannerViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func addScannerView(to dataScannerViewController: DataScannerViewController) {
        // Create and add the corner overlay
        let overlayView = ScannerOverlayView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .clear
        dataScannerViewController.view.addSubview(overlayView)
        
        let overlaySize: CGFloat = 200.0
        
        // Center the overlay view and set its size using Auto Layout constraints
        NSLayoutConstraint.activate([
            overlayView.centerXAnchor.constraint(equalTo: dataScannerViewController.view.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: dataScannerViewController.view.centerYAnchor),
            overlayView.widthAnchor.constraint(equalToConstant: overlaySize),
            overlayView.heightAnchor.constraint(equalToConstant: overlaySize)
        ])
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        
    }
    
    func startScanning() {
        coordinator.startScanning()
    }
    
    func stopScanning() {
        coordinator.stopScanning()
    }
    
    // Coordinator to act as delegate
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        private let barcodes: PassthroughSubject<String, Never>
        weak var dataScannerViewController: DataScannerViewController?
        
        init(barcodes: PassthroughSubject<String, Never>) {
            self.barcodes = barcodes
        }
        
        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didAdd addedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {
            // Process recognized items and send barcode value
            if let firstItem = addedItems.first,
               case let .barcode(barcode) = firstItem,
               let stringValue = barcode.payloadStringValue {
                logger.log(level: .info, "barcode received: \(stringValue)")
                barcodes.send(stringValue) // Publish the barcode string
            }
        }
        
        func dataScanner(
            _ dataScanner: DataScannerViewController,
            becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable
        ) {
            // relay this message back to the UI somehow
        }
        
        func startScanning() {
            try? dataScannerViewController?.startScanning()
        }
        
        func stopScanning() {
            dataScannerViewController?.stopScanning()
        }
        
        @objc func closeButtonTapped() {
            dataScannerViewController?.stopScanning()
            dataScannerViewController?.dismiss(animated: true)
        }
    }
}


