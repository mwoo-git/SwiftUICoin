//
//  HomeView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showMenu: Bool = false
    
    var body: some View {
        ZStack {
            // Background layer
            Color.theme.background
                .ignoresSafeArea()
            
            // content layer
            VStack(spacing: 0) {
                homeHeader
                listOptionBar
                sortOptionList
                allCoinList
                Spacer(minLength: 0)
            }
        }
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
            IconView(iconName: showMenu ? "arrow.left" : "person.circle")
                .onTapGesture {
                    withAnimation() {
                        showMenu.toggle()
                    }
                }
                .animation(.none, value: showMenu)
            
            Spacer()
            
            if !showMenu {
                HStack {
                    IconView(iconName: "magnifyingglass")
                        .padding(.trailing, -20)
                    
                    IconView(iconName: "qrcode.viewfinder")
                }
            } else {
                IconView(iconName: "sun.min.fill")
                    .padding(.trailing, 18)
            }
        }
    }
    
    private var sortOptionList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 45) {
                Text("Market Cap")
                    .foregroundColor(Color.white)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color.theme.sortOption))
                
                let iconSize = 13
                
                HStack(spacing: 0) {
                    Text("Price")
                    Image(systemName: "arrow.down")
                        .font(.system(size: CGFloat(iconSize)))
                    Image(systemName: "arrow.up")
                        .font(.system(size: CGFloat(iconSize)))
                }
                
                HStack(spacing: 0) {
                    Text("24h Change")
                    Image(systemName: "arrow.down")
                        .font(.system(size: CGFloat(iconSize)))
                    Image(systemName: "arrow.up")
                        .font(.system(size: CGFloat(iconSize)))
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color.theme.accent)
            
        }
        .padding()
    }
    
    private var listOptionBar: some View {
        HStack(alignment: .top, spacing: 30) {
            Text("Watchlist")
            VStack() {
                Text("Coin")
                    .foregroundColor(Color.white)
                Capsule()
                    .fill(Color.theme.BinanceColor)
                    .frame(width: 30, height: 3)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 15)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
    }
    
    private var allCoinList: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.allCoins) { coin in
                    CoinRowView(coin: coin)
                }
            }
        }
    }
}
