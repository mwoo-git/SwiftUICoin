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
    
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin)) // coin값을 초기 설정
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    tradingView
                    info
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
            DetailView(coin: dev.coin)
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
                KFImage(URL(string: viewModel.coin.image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                Text(viewModel.coin.symbol.uppercased())
                    .bold()
            }
            Spacer()
            Image(systemName: homeViewModel.isWatchlistExists(coin: viewModel.coin) ? "star.fill" : "star")
                .foregroundColor(homeViewModel.isWatchlistExists(coin: viewModel.coin) ? Color.theme.binanceColor : Color.theme.accent)
                .padding()
                .onTapGesture {
                    homeViewModel.updateWatchlist(coin: viewModel.coin)
                }
        }
        .background(Color.theme.background)
    }
    
    private var tradingView: some View {
        TradingView(symbol: Usd.usd.contains(viewModel.coin.symbol) ? "\(viewModel.coin.symbol.uppercased())USD" : "\(viewModel.coin.symbol.uppercased())USDT")
            .frame(height: UIScreen.main.bounds.height / 1.75)
            .frame(width: UIScreen.main.bounds.width)
            .padding(.bottom)
            .background(Color.theme.background)
    }
    
    private var listOption: some View {
        HStack(alignment: .top, spacing: 30) {
            VStack {
                Text("최신 뉴스")
                    .foregroundColor(viewModel.infoOption == .news ? Color.theme.textColor : Color.theme.accent)
                Capsule()
                    .fill(viewModel.infoOption == .news ? Color.theme.textColor : .clear)
                    .frame(width: 30, height: 2)
            }
            .onTapGesture {
                viewModel.infoOption = .news
            }
            VStack() {
                Text("\(viewModel.coin.symbol.uppercased()) 정보")
                    .foregroundColor(viewModel.infoOption == .about ? Color.theme.textColor : Color.theme.accent)
                Capsule()
                    .fill(viewModel.infoOption == .about ? Color.theme.textColor : .clear)
                    .frame(width: 30, height: 2)
            }
            .onTapGesture {
                viewModel.infoOption = .about
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 15)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
        .background(Color.theme.background)
    }
    
    private var info: some View {
        LazyVStack(
            pinnedViews: [.sectionHeaders]) {
                Section(header: listOption) {
                    if viewModel.infoOption == .news {
                        if viewModel.articles.isEmpty {
                            ArticlePlaceholderView()
                        } else {
                            LazyVStack {
                                ForEach(viewModel.articles.prefix(5)) { article in
                                    NavigationLink(destination: NavigationLazyView(ArticleWebView(article: article))) {
                                        ArticleView(article: article)
                                    }
                                    .buttonStyle(ListSelectionStyle())
                                }
                                
                            }
                            .padding(.top)
                        }
                    } else {
                        DetailStatsView(viewModel: viewModel)
                    }
                }
                
            }
            .background(Color.theme.background)
    }
}

struct Usd {
    static let usd: [String] = ["usdt", "usdc", "busd"]
}
