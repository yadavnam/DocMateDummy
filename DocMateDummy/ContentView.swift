//
//  ContentView.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 23/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(AppViewModel.self) var viewModel
    
    var body: some View {
        TabView{
            NavigationStack{
                HomeView()
            }.tabItem{
                Label("Home", systemImage: "house")
            }
            NavigationStack{
                
            }.tabItem{
                Label("Add", systemImage: "plus")
            }
            NavigationStack{
                BrowseView()
            }.tabItem{
                Label("Browse", systemImage: "folder")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppViewModel())
}
