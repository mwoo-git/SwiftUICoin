//
//  MyTabView2.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/28.
//

import SwiftUI

struct MyTabView: View {
    
    @State private var isNavigationBarHidden: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @State private var selection = 0
    
    init() {
//        let appearance = UITabBar.appearance()
//        appearance.backgroundColor = UIColor(named: "TabbarBackgroundColor")
//        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // <- HERE
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.accentColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.accentColor)]
        
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(selection  == 0 ? "home_selected" : "home_unselected")
                        .renderingMode(.template)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("홈")
                }
                .navigationTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                })
                .tag(0)
            
            HeadlineView()
                .tabItem {
                    Image(selection  == 1 ? "search_selected" : "search_unselected")
                        .renderingMode(.template)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("뉴스")
                }
                .navigationTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                })
                .tag(1)
        }
        .accentColor(Color.theme.textColor)
    }
}

struct MyTabView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyTabView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}
