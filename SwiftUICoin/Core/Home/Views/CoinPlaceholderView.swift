//
//  CoinPlaceholderView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/04.
//

import SwiftUI
import Kingfisher

struct CoinPlaceholderView: View {
    
    let coin: CoinModel
    @State private var opacity: Double = 1
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            rightColmn
        }
        .padding()
        .contentShape(Rectangle())
        .redacted(reason: .placeholder)
        .opacity(opacity)
        .onAppear {
            withAnimation {
                opacity = 0.2
            }
        }
        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: opacity)
    }
}

struct CoinPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinPlaceholderView(coin: dev.coin)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            CoinPlaceholderView(coin: dev.coin)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension CoinPlaceholderView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            
            KFImage(URL(string: coin.image))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .cornerRadius(20)
                
            VStack(alignment: .leading, spacing: 4) {
                Text("btcbtc")
                                .font(.headline)
                Text("Ethereumbitcoin")
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
            Text(coin.priceChangePercentage24H.asPercentString())
                .font(.subheadline)
        }
    }
}

