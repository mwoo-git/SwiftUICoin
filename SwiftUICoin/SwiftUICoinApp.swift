//
//  SwiftUICoinApp.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/11.
//

import SwiftUI

@main
struct SwiftUICoinApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var webSocketService = UpbitWebSocketService.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("앱 시작")
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // 앱이 백그라운드에서 포그라운드로 이동할 때 WebSocket 서비스 연결
        webSocketService.connect()
        print("백그라운드 -> 포그라운드")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // 앱이 백그라운드로 이동할 때 WebSocket 서비스 연결 종료
        webSocketService.close()
        print("포그라운드 -> 백그라운드")
    }
}
