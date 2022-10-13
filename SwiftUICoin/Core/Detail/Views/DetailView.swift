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
    
    init(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            _viewModel = StateObject(wrappedValue: DetailViewModel(coin: nil, backup: backup))
        } else {
            _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin, backup: nil))
        }
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
    
    private var tradingView: some View {
        TradingView(symbol: Usd.usd.contains((viewModel.coin?.symbol ?? viewModel.backup?.symbol) ?? "") ? "\((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "")USD" : "\((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "")USDT")
            .frame(height: UIScreen.main.bounds.height / 1.75)
            .frame(width: UIScreen.main.bounds.width)
            .padding(.bottom)
            .background(Color.theme.background)
    }
}

struct Usd {
    static let usd: [String] = ["usdt", "usdc", "busd"]
}
