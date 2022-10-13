//
//  DetailView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/19.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    
    @StateObject var viewModel: DetailViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var currentTab: Int = 0
    @Namespace var namespace
    
    init(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            _viewModel = StateObject(wrappedValue: DetailViewModel(coin: nil, backup: backup))
        } else {
            _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin, backup: nil))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    tradingView
                    info
                    if !homeViewModel.allCoins.isEmpty {
                        TopMoversView()
                        LowMoversView()
                    }
                }
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin, backup: nil)
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

extension DetailView {
    private var header: some View {
        HStack {
            BackButtonView()
            Spacer()
            HStack() {
                KFImage(URL(string: (viewModel.backup?.image ??  viewModel.coin?.image) ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                Text((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "")
                    .bold()
            }
            Spacer()
            if viewModel.coin == nil {
                Image(systemName: homeViewModel.isWatchlistExists(coin: nil, backup: viewModel.backup) ? "star.fill" : "star")
                    .foregroundColor(homeViewModel.isWatchlistExists(coin: nil, backup: viewModel.backup) ? Color.theme.binanceColor : Color.theme.accent)
                    .padding()
                    .onTapGesture {
                        homeViewModel.updateWatchlist(coin: nil, backup: viewModel.backup)
                    }
            } else {
                Image(systemName: homeViewModel.isWatchlistExists(coin: viewModel.coin, backup: nil) ? "star.fill" : "star")
                    .foregroundColor(homeViewModel.isWatchlistExists(coin: viewModel.coin, backup: nil) ? Color.theme.binanceColor : Color.theme.accent)
                    .padding()
                    .onTapGesture {
                        homeViewModel.updateWatchlist(coin: viewModel.coin, backup: nil)
                    }
            }
        }
        .background(Color.theme.background)
    }
    
    private var tradingView: some View {
        TradingView(symbol: Usd.usd.contains((viewModel.coin?.symbol ?? viewModel.backup?.symbol) ?? "") ? "\((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "")USD" : "\((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "")USDT")
            .frame(height: UIScreen.main.bounds.height / 1.75)
            .frame(width: UIScreen.main.bounds.width)
            .padding(.bottom)
            .background(Color.theme.background)
    }
    
    private var listOption: some View {
        HStack {
            VStack {
                Text("주요 뉴스")
                    .foregroundColor(currentTab == 0 ? Color.theme.textColor : Color.theme.accent)
                    .font(.headline)
                    .fontWeight(currentTab == 0 ? .bold : .regular)
                if currentTab == 0 {
                    Color.theme.textColor
                        .frame(width: 30, height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                        
                } else {
                    Color.clear.frame(width: 30, height: 2)
                }
            }
            .animation(.easeInOut(duration: 0.2),  value: currentTab)
            .onTapGesture {
                    currentTab = 0
            }
            VStack {
                Text("\((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "") 정보")
                    .foregroundColor(currentTab == 1 ? Color.theme.textColor : Color.theme.accent)
                    .font(.headline)
                    .fontWeight(currentTab == 1 ? .bold : .regular)
                if currentTab == 1 {
                    Color.theme.textColor
                        .frame(width: 30, height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                } else {
                    Color.clear.frame(width: 30, height: 2)
                }
            }
            .animation(.easeInOut(duration: 0.2),  value: currentTab)
            .onTapGesture {
                    currentTab = 1
            }
            .padding(.leading)
            Spacer()
        }
        .font(.headline)
        .padding(.horizontal)
        .padding(.top)
        .foregroundColor(Color.theme.accent)
        .background(Color.theme.background)
    }
    
    private var info: some View {
        LazyVStack(
            pinnedViews: [.sectionHeaders]) {
                Section(header: listOption) {
                    if viewModel.articles.isEmpty {
                        ArticlePlaceholderView()
                    } else {
                        TabView(selection: $currentTab) {
                            LazyVStack {
                                ForEach(viewModel.articles.prefix(4)) { article in
                                    NavigationLink(destination: NavigationLazyView(ArticleWebView(article: article))) {
                                        ArticleView2(article: article)
                                    }
                                    .buttonStyle(ListSelectionStyle())
                                }
                                Spacer()
                            }
                            .tag(0)
                            
                            DetailStatsView(viewModel: viewModel).tag(1)
                        }
                        .frame(height: 600)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                }
            }
            .background(Color.theme.background)
    }
}

struct Usd {
    static let usd: [String] = ["usdt", "usdc", "busd"]
}
