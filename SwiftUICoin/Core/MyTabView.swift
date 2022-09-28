//
//  MyTabView2.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/28.
//

import SwiftUI

struct MyTabView: View {
    
    @State private var isNavigationBarHidden: Bool = true
    @State private var selection = 0
    
    init() {
        let appearance = UITabBar.appearance()
        appearance.unselectedItemTintColor = UIColor.white
        appearance.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            HomeView()
                .tabItem {
                    Image(systemName: selection  == 0 ? "chart.bar.fill" : "chart.bar")
                        .environment(\.symbolVariants, .none)
                    Text("Markets")
                }
                .navigationTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                })
                .tag(0)
            
            Color.red
                .tabItem {
                    Image(systemName: selection == 1 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, .none)
                    Text("Watchlist")
                }
                .navigationTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                })
                .tag(1)
            
        }
        .accentColor(.white)
        
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
