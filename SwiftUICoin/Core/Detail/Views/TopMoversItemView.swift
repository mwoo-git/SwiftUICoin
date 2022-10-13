//
//  TopMoversItemView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/13.
//

import SwiftUI
import Kingfisher

struct TopMoversItemView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack(alignment: .leading) {
            // image
            HStack {
                KFImage(URL(string: coin.image))
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.horizontal)
                Spacer()
            }
            
            // coin info
            Text(coin.symbol.uppercased())
                .padding(.horizontal)
                .lineLimit(1)
            
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // coin percent change
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .font(.headline)
                .foregroundColor(coin.priceChangePercentage24H ?? 0 > 0 ? .green : .red)
                .padding(.horizontal)
        }
        .frame(width: 130, height: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct TopMoversItemView_Previews: PreviewProvider {
    static var previews: some View {
        TopMoversItemView(coin: dev.coin)
    }
}
