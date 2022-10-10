//
//  DetailStatsView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/21.
//

import SwiftUI

struct DetailStatsView: View {
    
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
            VStack {
                rank
                ForEach(viewModel.statistics) { stat in
                    StatisticView(stat: stat)
                }
                explorer
                introduction
            }
    }
}

struct DetailStatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailStatsView(viewModel: DetailViewModel(coin: dev.coin, backup: nil))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            DetailStatsView(viewModel: DetailViewModel(coin: dev.coin, backup: nil))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension DetailStatsView {
    private var rank: some View {
        HStack {
            Text("Rank")
                .foregroundColor(Color.theme.accent)
            Spacer()
            HStack(alignment: .lastTextBaseline) {
//                Image(systemName: "chart.bar.xaxis")
//                    .foregroundColor(Color.theme.binanceColor)
//                    .font(.subheadline)
                Text("No. \((viewModel.coin?.marketCapRank?.convertRank ?? viewModel.backup?.rank.convertRank) ?? 0)")
            }
        }
        .padding()
    }
    
    private var explorer: some View {
        HStack {
            Text("Explorer")
                .foregroundColor(Color.theme.accent)
            Spacer()
            if let websiteString = viewModel.websiteURL,
               !websiteString.isEmpty {
                HStack {
                    NavigationLink(destination: CoinWebView(viewModel: viewModel)) {
                        Text("웹사이트")
                    }
                    Image(systemName: "arrow.up.forward.square")
                        .font(.subheadline)
                }
                .foregroundColor(Color.theme.openseaColor)
            }
        }
        .padding()
    }
    
    private var introduction: some View {
        VStack {
            HStack {
                Text("Introduction")
                    .foregroundColor(Color.theme.accent)
                Spacer()
            }
            .padding(.bottom)
            
            if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
                Text(coinDescription)
            }
        }
        .padding()
    }
}
