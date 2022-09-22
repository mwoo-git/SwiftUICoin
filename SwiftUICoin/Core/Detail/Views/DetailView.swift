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
                    VStack(alignment: .leading, spacing: 0) {
                        TradingView(symbol: Binance.usdt.contains(viewModel.coin.symbol) ? "\(viewModel.coin.symbol.uppercased())USDT" : "\(viewModel.coin.symbol.uppercased())USD")
                            .frame(height: 480)
                            .frame(width: UIScreen.main.bounds.width)
                            .background(Color.theme.background)
                        
                        comments
                        Divider()
                            .padding(.bottom, 15)
                        
                        LazyVStack(
                            pinnedViews: [.sectionHeaders]) {
                                Section(header: listOptionBar) {
                                    VStack {
                                        HStack {
                                            DetailStatsView(viewModel: viewModel)
                                        }
                                    }
                                }
                            }
                            .background(Color.theme.background)
                        Spacer()
                    }
                    .navigationBarHidden(true)
                }
            }
        }
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
    
    private var listOptionBar: some View {
        HStack(alignment: .top, spacing: 30) {
            Text("News")
            VStack() {
                Text("About \(viewModel.coin.symbol.uppercased())")
                    .foregroundColor(Color.white)
                Capsule()
                    .fill(Color.theme.binanceColor)
                    .frame(width: 30, height: 3)
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
        }
        .padding()
    }
}

struct Binance {
    static let usdt: [String] = ["btc", "eth", "bnb"]
}
