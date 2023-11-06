//
//  CinemaApp.swift
//  Cinema
//
//  Created by Helen on 16.10.2023.
//

import SwiftUI

@main
struct CinemaApp: App {
    var body: some Scene {
        WindowGroup {
            AppTabView()
        }
    }
}

struct AppTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "popcorn.fill")
                }
            UpcomingView()
                .tabItem {
                    Label("Upcoming", systemImage: "bolt")
                }
        }
    }
}
