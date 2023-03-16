//
//  SwiftUICoinApp.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/11.
//

import SwiftUI

@main
struct SwiftUICoinApp: App {
    
    @Environment(\.scenePhase) var scenePhase

    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var binanceViewModel = BinanceCoinViewModel()
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
                .environmentObject(binanceViewModel)
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
        .onChange(of: scenePhase) { newScenePhase in
                   switch newScenePhase {
                   case .active:
                       UpbitWebSocketService.shared.connect()
                       print("App is active")
                   case .inactive:
                       UpbitRestApiService.shared.fetchTickers()
                       UpbitWebSocketService.shared.close()
                       print("App is inactive")
                   case .background:
                       print("App is in background")
                   @unknown default:
                       print("unexpected Value")
                   }
               }
    }
}
