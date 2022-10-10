//
//  SearchRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/29.
//

import SwiftUI
import Kingfisher

struct EditCoinRowView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var coin: CoinModel?
    var backup: BackupCoinEntity?
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            rightColmn
        }
        .padding()
    }
}

struct SearchRowView_Previews: PreviewProvider {
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

extension EditCoinRowView {
    
    private var leftColumn: some View {
        HStack(alignment: .center, spacing: 0) {
            
            KFImage(URL(string: (coin?.image ?? backup?.image) ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text((coin?.symbol.uppercased() ?? backup?.symbol?.uppercased()) ?? "")
                    .font(.headline)
                    .foregroundColor(Color.theme.textColor)
                Text((coin?.name ?? backup?.name) ?? "")
                    .foregroundColor(Color.theme.accent)
                    .font(.subheadline)
            }
            .padding(.leading, 14)
        }
    }
    
    private var rightColmn: some View {
        HStack {
            if coin == nil {
                if !viewModel.isWatchlistExists(coin: nil, backup: backup) {
                    Image(systemName: "plus.circle")
                } else {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(Color.theme.binanceColor)
                }
            } else {
                if !viewModel.isWatchlistExists(coin: coin, backup: nil) {
                    Image(systemName: "plus.circle")
                } else {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(Color.theme.binanceColor)
                }
            }
            
        }
        .onTapGesture {
            if coin == nil {
                viewModel.updateWatchlist(coin: nil, backup: backup)
            } else {
                viewModel.updateWatchlist(coin: coin, backup: nil)
            }
             
        }
        .font(.subheadline)
    }
}
