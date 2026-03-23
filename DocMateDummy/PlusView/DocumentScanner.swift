//
//  DocumentScanner.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 23/03/26.
//

import SwiftUI
import VisionKit

// MARK: - VisionKit Document Scanner (Like CamScanner / Adobe Scan)

struct DocumentScanner: UIViewControllerRepresentable {

    var onScanCompleted: ([UIImage]) -> Void
    var onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onScanCompleted: onScanCompleted, onCancel: onCancel)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    // MARK: Coordinator
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {

        var onScanCompleted: ([UIImage]) -> Void
        var onCancel: () -> Void

        init(onScanCompleted: @escaping ([UIImage]) -> Void, onCancel: @escaping () -> Void) {
            self.onScanCompleted = onScanCompleted
            self.onCancel = onCancel
        }

        // ✅ Scan completed - saare pages milte hain
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {
            var scannedImages: [UIImage] = []
            for pageIndex in 0..<scan.pageCount {
                scannedImages.append(scan.imageOfPage(at: pageIndex))
            }
            controller.dismiss(animated: true) {
                self.onScanCompleted(scannedImages)
            }
        }

        // ❌ Cancel
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true) {
                self.onCancel()
            }
        }

        // ⚠️ Error
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            controller.dismiss(animated: true) {
                self.onCancel()
            }
        }
    }
}

// MARK: - Availability Check

extension DocumentScanner {
    static var isSupported: Bool {
        VNDocumentCameraViewController.isSupported
    }
}
