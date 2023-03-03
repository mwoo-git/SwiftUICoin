//
//  HomeView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var UpbitViewModel: UpbitCoinViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showMenu = false
    @State private var isDark = false
    
    var body: some View {
        VStack(spacing: 0) {
            homeHeader
            UpbitCoinListView()
//            HomeCoinListView()
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
            Text("BlockWide")
                .font(.title2)
                .bold()
                .padding(.leading)
            Spacer()
            HStack(spacing: 15) {
                Button {
                    UpbitViewModel.showTickers.toggle()
                } label: {
                    Text(UpbitViewModel.showTickers ? "시작" : "정지")
                }

                NavigationLink(
                    destination: SearchView()) {
                        IconView(iconName: "magnifyingglass")
                    }
                SettingsButtonView()
            }
            .padding(.trailing)
        }
        .frame(height: 50)
    }
}

