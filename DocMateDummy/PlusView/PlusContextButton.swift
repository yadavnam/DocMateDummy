//
//  PlusContextButton.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 23/03/26.
//

import SwiftUI

struct PlusContextButton: View {

    @Binding var showScanner:     Bool
    @Binding var showPhotoPicker: Bool

    @State private var showDialog = false

    var body: some View {
        Color.clear
            .frame(width: 80, height: 49)
            .contentShape(Rectangle())
            .onTapGesture {
                showDialog = true
            }
            .confirmationDialog("Add Document", isPresented: $showDialog, titleVisibility: .visible) {
                Button("Scan from Camera") {
                    showScanner = true
                }
                Button("Upload from Gallery or Files") {
                    showPhotoPicker = true
                }
                Button("Cancel", role: .cancel) {}
            }
    }
}
