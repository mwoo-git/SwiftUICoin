//
//  SwiftUICoinApp.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/11.
//

import SwiftUI

@main
struct SwiftUICoinApp: App {

    @StateObject private var viewModel = HomeViewModel()
    @StateObject var globalViewModel = GlobalViewModel()
    @StateObject private var monitor = NetworkMonitor()
    @State private var isNavigationBarHidden = true
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var showLaunchView = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    VStack {
                        MyTabView()
                            .navigationBarTitle("Hidden Title")
                            .navigationBarHidden(self.isNavigationBarHidden)
                            .onAppear {
                                self.isNavigationBarHidden = true
                            }
                        if !monitor.isConnected || monitor.showAlert {
                            NetworkMissingView()
                        }
                    }
                }
                .environmentObject(viewModel)
                .environmentObject(globalViewModel)
                .environmentObject(monitor)
                .navigationViewStyle(.stack)
//                .environment(\.colorScheme, isDarkMode ? .dark : .light)
                .environment(\.colorScheme, .dark)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
//                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
