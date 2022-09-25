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
    @State private var showNews: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin)) // coin값을 초기 설정
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                datailHeader
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        tradingView
                        comments
                        Divider()
                            .padding(.bottom, 15)
                        info
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
            .preferredColorScheme(.dark)
    }
}

extension DetailView {
    private var datailHeader: some View {
        HStack {
            IconView(iconName: "arrow.left")
                .onTapGesture {
                    withAnimation() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
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
            IconView(iconName: "star.fill")
        }
        .background(Color.theme.coinDetailBackground)
    }
    
    private var tradingView: some View {
        TradingView(symbol: NotUsdt.usd.contains(viewModel.coin.symbol) ? "\(viewModel.coin.symbol.uppercased())USD" : "\(viewModel.coin.symbol.uppercased())USDT")
            .frame(height: UIScreen.main.bounds.height / 1.75)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.theme.background)
    }
    
    private var listOptionBar: some View {
        HStack(alignment: .top, spacing: 30) {
            VStack {
                Text("News")
                    .foregroundColor(showNews ? Color.white : Color.theme.accent)
                Capsule()
                    .fill(showNews ? Color.theme.binanceColor : .clear)
                    .frame(width: 30, height: 3)
            }
            .onTapGesture {
                showNews.toggle()
            }
            VStack() {
                Text("About \(viewModel.coin.symbol.uppercased())")
                    .foregroundColor(!showNews ? Color.white : Color.theme.accent)
                Capsule()
                    .fill(!showNews ? Color.theme.binanceColor : .clear)
                    .frame(width: 30, height: 3)
            }
            .onTapGesture {
                showNews.toggle()
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 15)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
        .background(Color.theme.background)
    }
    
    private var comments: some View {
        VStack(spacing: 15) {
            HStack {
                Text("댓글")
                    .foregroundColor(Color.white)
                Text("175")
                    .foregroundColor(Color.theme.accent)
                    .font(.subheadline)
                    .padding(.leading, 5)
                Spacer()
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.subheadline)
            }
            HStack {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 28, height: 28)
                Text("비트코인 더 올라갈까요?")
                Spacer()
            }
            .padding(.bottom, 5)
        }
        .padding()
    }
    
    private var info: some View {
        LazyVStack(
            pinnedViews: [.sectionHeaders]) {
                Section(header: listOptionBar) {
                    VStack {
                        HStack {
                            if showNews {
                                ArticleListView(viewModel: viewModel)
                            } else {
                                DetailStatsView(viewModel: viewModel)
                            }
                        }
                    }
                }
            }
            .background(Color.theme.background)
    }
}

struct NotUsdt{
    static let usd: [String] = ["usdt", "usdc", "busd"]
}
