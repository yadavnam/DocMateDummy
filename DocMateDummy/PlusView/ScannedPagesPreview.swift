//
//  ScannedPagesPreview.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 23/03/26.
//

import SwiftUI

struct ScannedPagesPreview: View {

    let pages: [UIImage]
    var onDone: () -> Void

    @Environment(AppViewModel.self) var viewModel

    @State private var selectedIndex    = 0
    @State private var documentName     = ""
    @State private var selectedCategory: Category? = nil
    @FocusState private var nameFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Thumbnail Strip (multi-page) ─────────────────────
                if pages.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(pages.indices, id: \.self) { i in
                                Image(uiImage: pages[i])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                i == selectedIndex ? Color.accentColor : Color.clear,
                                                lineWidth: 2.5
                                            )
                                    )
                                    .onTapGesture { selectedIndex = i }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemGroupedBackground))
                }

                // ── Main Preview ──────────────────────────────────────
                TabView(selection: $selectedIndex) {
                    ForEach(pages.indices, id: \.self) { i in
                        Image(uiImage: pages[i])
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: pages.count > 1 ? .automatic : .never))
                .frame(maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))

                // ── Form ──────────────────────────────────────────────
                VStack(spacing: 12) {

                    // Document Name
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundStyle(.secondary)
                        TextField("Enter Document Name", text: $documentName)
                            .focused($nameFocused)
                            .submitLabel(.done)
                    }
                    .padding(12)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
/*
                    // Category Picker
                    if let binding = categoryBinding {
                        HStack {
                            Image(systemName: "folder")
                                .foregroundStyle(.secondary)
                            Picker("Category", selection: binding) {
                                ForEach(viewModel.categories) { cat in
                                    HStack {
                                        Image(systemName: cat.sfSymbol)
                                        Text(cat.name)
                                    }
                                    .tag(cat)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.primary)
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                    }
*/
                    // Page count
                    Text("\(pages.count) page\(pages.count > 1 ? "s" : "") scanned")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    // Save Button
                    Button {
                        nameFocused = false
                        let name = documentName.isEmpty
                            ? "Scanned Document \(formattedDate())"
                            : documentName
                        let cat = selectedCategory ?? viewModel.categories[0]

                        let newDoc = Document(
                            name       : name,
                            isPinned   : false,
                            userId     : viewModel.user.id,
                            categoryId : cat.id,
                            createdAt  : Date(),
                            fileType   : .image
                        )
                        viewModel.addDocument(newDoc, images: pages)
                        onDone()
                    } label: {
                        Label("Save Document", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(16)
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Save Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDone() }
                }
            }
            .onAppear {
                selectedCategory = viewModel.categories.first
            }
        }
    }

    // Picker ke liye non-optional Binding
    private var categoryBinding: Binding<Category>? {
        guard selectedCategory != nil else { return nil }
        return Binding(
            get: { self.selectedCategory ?? self.viewModel.categories[0] },
            set: { self.selectedCategory = $0 }
        )
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.dateFormat = "dd MMM yyyy, hh:mm a"
        return f.string(from: .now)
    }
}
