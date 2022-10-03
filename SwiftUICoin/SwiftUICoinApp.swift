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
    @State private var isNavigationBarHidden: Bool = true
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // 홈뷰에선 네비게이션 바가 보이지 않습니다.
                MyTabView()
                    .navigationBarTitle("Hidden Title")
                    .navigationBarHidden(self.isNavigationBarHidden)
                    .onAppear {
                        self.isNavigationBarHidden = true
                    }
                
            }
            .environmentObject(viewModel)// 모든 자식뷰가 viewModel에 엑세스 할 수 있습니다.
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
