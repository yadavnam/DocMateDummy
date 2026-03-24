//
//  ContentView.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 23/03/26.
//

import SwiftUI

struct ContentView: View {

    @Environment(AppViewModel.self) var viewModel

    @State private var selectedTab     = 0
    @State private var showScanner     = false
    @State private var showPhotoPicker = false

    var body: some View {

        TabView(selection: $selectedTab) {
            
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            NavigationStack { EmptyView() }
                .tabItem { }
                .tag(1)

            NavigationStack { BrowseView() }
                .tabItem { Label("Browse", systemImage: "folder") }
                .tag(2)
        }
        
        .overlay(alignment: .bottom) {
            PlusContextButton(
                showScanner: $showScanner,
                showPhotoPicker: $showPhotoPicker
            )
            .padding(.bottom, 20)
        }
        .fullScreenCover(isPresented: $showScanner) {
            AddDocumentCoordinator(source: .camera)
                .environment(viewModel)
        }
        
        .sheet(isPresented: $showPhotoPicker) {
            AddDocumentCoordinator(source: .gallery)
                .environment(viewModel)
        }
    }
}

#Preview {
    ContentView()
        .environment(AppViewModel())
}
