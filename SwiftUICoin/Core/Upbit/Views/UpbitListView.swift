//
//  UpbitCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI

struct UpbitListView: View {
    
    let tickers: [UpbitTicker]
    
    var body: some View {
        List {
            ForEach(tickers) { ticker in
                UpbitRowView(ticker: ticker)
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
