//
//  HomeView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showMenu: Bool = false
    @State private var isDark: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            homeHeader
            HomeCoinListView()
        }
        .background(Color.theme.background.ignoresSafeArea())
        .environment(\.colorScheme, .dark)
//        .onAppear {
//            if viewModel.isDark {
//                isDarkMode  = true
//            } else {
//                isDarkMode = false
//            }
//        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            Text("마켓")
                .font(.title2)
                .bold()
                .padding(.leading)
            Spacer()
            HStack(spacing: 0) {
                NavigationLink(
                    destination: SearchView()) {
                        IconView(iconName: "magnifyingglass")
                    }
                SettingsButtonView()
            }
        }
    }
}

