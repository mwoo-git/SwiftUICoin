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
    @EnvironmentObject private var viewModel: HomeViewModel
    
    init() {
        let appearance = UITabBar.appearance()
//        appearance.unselectedItemTintColor = UIColor(Color.theme.textColor)
        appearance.backgroundColor = UIColor(named: "TabbarBackgroundColor")
    }
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            WatchlistView()
                .tabItem {
                    Image(systemName: selection == 0 ? "heart.fill" : "heart")
//                        .environment(\.symbolVariants, .none)
                    Text("Watchlist")
                }
                .environmentObject(viewModel)
                .navigationTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                            viewModel.addSubscribers()
                })
                .tag(0)
            
            HomeView()
                .tabItem {
                    Image(systemName: selection  == 1 ? "chart.bar.fill" : "chart.bar")
//                        .environment(\.symbolVariants, .none)
                    Text("Markets")
                }
                .navigationTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                })
                .tag(1)
            
            HeadlineView()
                .tabItem {
                    Image(systemName: selection  == 1 ? "newspaper.fill" : "newspaper")
//                        .environment(\.symbolVariants, .none)
                    Text("Headline")
                }
                .navigationTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                })
                .tag(2)
            
           
            
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
