//
//  SwiftUICoinApp.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/11.
//

import SwiftUI

@main
struct SwiftUICoinApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // 홈뷰에선 네비게이션 바가 보이지 않습니다.
                HomeView()
                    .navigationBarHidden(true)
                    
            }
        }
    }
}
