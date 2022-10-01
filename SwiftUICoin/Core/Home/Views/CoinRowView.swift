//
//  CoinRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI
import Kingfisher

struct CoinRowView: View {
    
    let coin: CoinModel
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            rightColmn
        }
        .padding()
        .contentShape(Rectangle())
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            
            KFImage(URL(string: coin.image))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.orange)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.symbol.uppercased())
                                .font(.headline)
                                .foregroundColor(Color.theme.textColor)
                Text(coin.name)
                    .foregroundColor(Color.theme.accent)
                    .font(.subheadline)
            }
            .padding(.leading, 14)
        }
    }
    
    private var rightColmn: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .font(.headline)
                .foregroundColor(Color.theme.textColor)
            Text(coin.priceChangePercentage24H.asPercentString())
                .foregroundColor((coin.priceChangePercentage24H) >= 0 ? Color.theme.green : Color.theme.red)
                .font(.subheadline)
        }
    }
}
