//
//  HomeView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
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
                            sortOptionBar
                        }.background(Color.theme.background)
                        ) {
                            AllCoinListView(viewModel: vm)
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
    
    private var sortOptionBar: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    HStack(spacing: 0) {
                        Text("Market Cap")
                            .foregroundColor((vm.sortOption == .rank) ? Color.white : Color.theme.accent)
                    }
                    .id("MARKET_CAP")
                    .padding(.vertical, 3)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                            .fill(vm.sortOption == .rank ? Color.theme.sortOptionSelected : .clear)
                    )
                    .onTapGesture {
                        vm.sortOption = .rank
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("MARKET_CAP", anchor: .topLeading)
                        }
                    }
                    
                    let iconSize = 13
                    
                    HStack(spacing: 0) {
                        Text("Price")
                            .foregroundColor((vm.sortOption == .price || vm.sortOption == .pricereversed) ? Color.white : Color.theme.accent)
                        Image(systemName: "arrow.down")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(vm.sortOption == .price ?  Color.white : vm.sortOption == .pricereversed ? Color.theme.background : Color.theme.accent)
                        Image(systemName: "arrow.up")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(vm.sortOption == .pricereversed ?  Color.white : vm.sortOption == .price ? Color.theme.background : Color.theme.accent)
                    }
                    .padding(.vertical, 3)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .background(
                        Capsule()
                            .fill((vm.sortOption == .price || vm.sortOption == .pricereversed) ? Color.theme.sortOptionSelected : .clear)
                    )
                    .onTapGesture {
                        vm.sortOption = vm.sortOption == .price ? .pricereversed : .price
                    }
                    
                    HStack(spacing: 0) {
                        Text("24h Change")
                            .foregroundColor((vm.sortOption == .priceChangePercentage24H || vm.sortOption == .priceChangePercentage24HReversed) ? Color.white : Color.theme.accent)
                        Image(systemName: "arrow.down")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(vm.sortOption == .priceChangePercentage24H ?  Color.white : vm.sortOption == .priceChangePercentage24HReversed ? Color.theme.background : Color.theme.accent)
                        Image(systemName: "arrow.up")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(vm.sortOption == .priceChangePercentage24HReversed ?  Color.white : vm.sortOption == .priceChangePercentage24H ? Color.theme.background : Color.theme.accent)
                    }
                    .id("24H_CHANGE")
                    .padding(.vertical, 3)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .background(
                        Capsule()
                            .fill((vm.sortOption == .priceChangePercentage24H || vm.sortOption == .priceChangePercentage24HReversed) ? Color.theme.sortOptionSelected : .clear)
                    )
                    .onTapGesture {
                        vm.sortOption = vm.sortOption == .priceChangePercentage24H ? .priceChangePercentage24HReversed : .priceChangePercentage24H
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("24H_CHANGE", anchor: .topTrailing)
                        }
                    }
                }
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.theme.accent)
            }
            .padding()
        }
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

