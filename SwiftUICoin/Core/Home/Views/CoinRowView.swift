//
//  CoinRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI
import Kingfisher

struct CoinRowView: View {
    
    var coin: CoinModel?
    var backup: BackupCoinEntity?
    
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
            CoinRowView(coin: dev.coin, backup: nil)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, backup: nil)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            
            KFImage(URL(string: coin == nil ? backup?.image ?? "" : coin?.image ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .cornerRadius(5)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(coin == nil ? backup?.symbol?.uppercased() ?? "" : coin?.symbol.uppercased() ?? "")
                                .font(.headline)
                                .foregroundColor(Color.theme.textColor)
                Text(coin == nil ? backup!.name! : coin!.name)
                    .foregroundColor(Color.theme.accent)
                    .font(.subheadline)
            }
            .padding(.leading, 14)
        }
    }
    
    private var rightColmn: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(coin == nil ? "$0.00" : coin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                .bold()
                .font(.headline)
                .foregroundColor(coin == nil ? Color.theme.accent : Color.theme.textColor)
            Text(coin == nil ? "0.00%" : coin?.priceChangePercentage24H?.asPercentString() ?? "" )
                .foregroundColor(coin == nil ? Color.theme.accent : (coin?.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                .font(.subheadline)
        }
    }
}
