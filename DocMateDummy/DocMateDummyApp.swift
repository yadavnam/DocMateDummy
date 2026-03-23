//
//  DocMateDummyApp.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 23/03/26.
//
import SwiftUI

@main
struct DocMateDummyApp: App {

    @State private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
