//
//  ContentView.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 23/03/26.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedTab     = 0
    @State private var showScanner     = false
    @State private var showPhotoPicker = false

    var body: some View {

        TabView(selection: $selectedTab) {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            Color.clear
                .tabItem { Label("Add", systemImage: "plus") }
                .tag(1)

            NavigationStack { BrowseView() }
                .tabItem { Label("Browse", systemImage: "folder") }
                .tag(2)
        }
        .onChange(of: selectedTab) {
            if selectedTab == 1 { selectedTab = 0 }
        }
        .overlay(alignment: .bottom) {
            PlusContextButton(
                showScanner:     $showScanner,
                showPhotoPicker: $showPhotoPicker
            )
        }
        .fullScreenCover(isPresented: $showScanner) {
            AddDocumentCoordinator(source: .camera)
        }
        .sheet(isPresented: $showPhotoPicker) {
            AddDocumentCoordinator(source: .gallery)
        }
    }
}

#Preview {
    ContentView()
        .environment(AppViewModel())
}
