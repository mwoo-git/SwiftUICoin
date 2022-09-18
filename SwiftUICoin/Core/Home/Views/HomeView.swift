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
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background layer
            Color.theme.background
                .ignoresSafeArea()
            
            // content layer
            VStack(spacing: 0) {
                
                homeHeader
                homeBody
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
                    NavigationLink(
                        destination: SearchView()) {
                            IconView(iconName: "magnifyingglass")
                                .padding(.trailing, -20)
                        }
                    IconView(iconName: "qrcode.viewfinder")
                }
            } else {
                IconView(iconName: "sun.min.fill")
                    .padding(.trailing, 18)
            }
        }
    }
    
    private var homeBody: some View {
        ScrollViewReader {proxyReader in
            ScrollView() {
                VStack {
                    TotalBalanceView()
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: VStack(spacing: 0) {
                            listOptionBar
                            sortOptionList
                        }.background(Color.theme.background)
                        ) {
                            AllCoinListView(viewModel: viewModel)
                        }
                    }
                }
                .id("SCROLL_TO_TOP")
                .overlay(scrollToTopGeometryReader)
            }
            .overlay(
                scrollToTopButton
                    .onTapGesture {
                        withAnimation {
                            proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                        }
                    }
                ,alignment: .bottomTrailing
            )
        }
        
    }
    
    private var listOptionBar: some View {
        HStack(alignment: .top, spacing: 30) {
            Text("Watchlist")
            VStack() {
                Text("Coin")
                    .foregroundColor(Color.white)
                Capsule()
                    .fill(Color.theme.binanceColor)
                    .frame(width: 30, height: 3)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
    }
    
    private var sortOptionList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 45) {
                Text("Market Cap")
                    .foregroundColor(Color.white)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 10)
                    .background(Color.theme.sortOption)
                    .cornerRadius(50)
                
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
    
    private var scrollToTopGeometryReader: some View {
        GeometryReader{proxy -> Color in
            DispatchQueue.main.async {
                if startOffset == 0 {
                    self.startOffset = proxy.frame(in: .global).minY
                }
                let offset = proxy.frame(in: .global).minY
                self.scrollViewOffset = offset - startOffset
            }
            return Color.clear
        }
    }
    
    private var scrollToTopButton: some View {
        Image(systemName: "arrow.up")
            .font(.title2)
            .foregroundColor(Color.white)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .foregroundColor(Color.theme.arrowButton)
            )
            .padding(.trailing, 30)
            .opacity(-scrollViewOffset > 145 ? 1: 0)
    }
}

