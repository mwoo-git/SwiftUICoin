//
//  DetailView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/19.
//

import SwiftUI
import Kingfisher

struct DetailView: View {

    @ObservedObject var viewModel: DetailViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    private var symbol: String {
        return (viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? ""
    }

    init(coin: CoinModel?, backup: BackupCoinEntity?) {
        viewModel = DetailViewModel(coin: coin, backup: backup)
    }

    var body: some View {
        VStack(spacing: 0) {
            DetailHeaderView(viewModel: viewModel)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    tradingView
                    DetailInfoView(viewModel: viewModel)
                    if !homeViewModel.allCoins.isEmpty {
                        TopMoversView()
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
    
    private var tradingView: some View {
        TradingViewChart(symbol: convertSymbol)
            .frame(height: UIScreen.main.bounds.height / 1.55)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.theme.background)
            .padding(.bottom)
    }
    
    var convertSymbol: String {
        if Usd.usd.contains(symbol) {
            return "\(symbol)USD"
        } else {
            return "BINANCE:\(symbol)USDT"
        }
    }
    
    struct Usd {
        static let usd: [String] = ["USDT", "USDC", "BUSD", "DAI"]
    }
}
