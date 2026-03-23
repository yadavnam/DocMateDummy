//
//  AddDocumentCoordinator.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 24/03/26.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

// Source type se directly coordinator ko pata hai kya karna hai
enum AddDocumentSource {
    case camera, gallery, files
}

struct AddDocumentCoordinator: View {

    let source: AddDocumentSource

    @Environment(\.dismiss) var dismiss
    @Environment(AppViewModel.self) var viewModel

    // Gallery picker
    @State private var pickerItems:    [PhotosPickerItem] = []

    // Result → preview
    @State private var scannedPages:   [UIImage] = []
    @State private var showPreview     = false

    var body: some View {
        Color.clear
            // ── Camera / VisionKit ────────────────────────────────
            .fullScreenCover(isPresented: shouldShowScanner) {
                DocumentScanner(
                    onScanCompleted: { images in
                        scannedPages = images
                        showPreview  = true
                    },
                    onCancel: { dismiss() }
                )
                .ignoresSafeArea()
            }

            // ── Photos Picker ─────────────────────────────────────
            .photosPicker(
                isPresented: shouldShowPhotoPicker,
                selection: $pickerItems,
                maxSelectionCount: 10,
                matching: .images
            )
            .onChange(of: pickerItems) {
                guard !pickerItems.isEmpty else { return }
                Task {
                    var images: [UIImage] = []
                    for item in pickerItems {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let img  = UIImage(data: data) { images.append(img) }
                    }
                    await MainActor.run {
                        scannedPages = images
                        pickerItems  = []
                        showPreview  = true
                    }
                }
            }

            // ── Files App ─────────────────────────────────────────
            .fileImporter(
                isPresented: shouldShowFilePicker,
                allowedContentTypes: [.image, .pdf],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    DocumentHandler.handleFiles(urls)
                }
                dismiss()
            }

            // ── Scan Preview with Category Picker ─────────────────
            .sheet(isPresented: $showPreview) {
                ScannedPagesPreview(pages: scannedPages) {
                    showPreview = false
                    dismiss()
                }
                .environment(viewModel)
            }

            .onAppear { triggerSource() }
    }

    // MARK: - Trigger on appear
    private func triggerSource() {
        switch source {
        case .camera:  break   // fullScreenCover binding handles it
        case .gallery: break   // photosPicker binding handles it
        case .files:   break   // fileImporter binding handles it
        }
    }

    // MARK: - Computed Bindings
    private var shouldShowScanner: Binding<Bool> {
        Binding(
            get: { source == .camera && !showPreview },
            set: { if !$0 { dismiss() } }
        )
    }
    private var shouldShowPhotoPicker: Binding<Bool> {
        Binding(
            get: { source == .gallery && !showPreview },
            set: { _ in }
        )
    }
    private var shouldShowFilePicker: Binding<Bool> {
        Binding(
            get: { source == .files && !showPreview },
            set: { if !$0 { dismiss() } }
        )
    }
}
