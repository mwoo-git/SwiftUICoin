//
//  UpbitCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI

struct UpbitListView: View {
    
    let tickers: [UpbitTicker]
    let coins: [UpbitCoin]
    
    var body: some View {
        List {
            ForEach(tickers) { ticker in
                if let coin = coins.first(where: { $0.market == ticker.market }) {
                    UpbitRowView(ticker: ticker, coin: coin)
                }
            }
            .listRowBackground(Color.theme.background)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .onAppear {
            UITableView.appearance().separatorColor = UIColor(Color.theme.background)
        }
        .background(Color.theme.background)
        
    }
}

//struct UpbitCoinListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpbitListView(tickers: <#[UpbitTicker]#>)
//    }
//}
