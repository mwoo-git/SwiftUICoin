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
            HStack {
                Text("Rank")
                    .foregroundColor(Color.theme.accent)
                Spacer()
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: "chart.bar.xaxis")
                        .foregroundColor(Color.theme.binanceColor)
                        .font(.subheadline)
                    Text("No. \(viewModel.coin.rank)")
                }
                
            }
            .padding()
            ForEach(viewModel.statistics) { stat in
                StatisticView(stat: stat)
            }
            HStack {
                Text("Explorer")
                    .foregroundColor(Color.theme.accent)
                Spacer()
                HStack(alignment: .firstTextBaseline) {
                    if let websiteString = viewModel.websiteURL,
                       let url = URL(string: websiteString) {
                        Link("Website", destination: url)
                    }
                    Image(systemName: "arrow.up.forward.square")
                        .font(.subheadline)
                }
                .foregroundColor(Color.theme.binanceColor)
                
            }
            .padding()
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
}

struct DetailStatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailStatsView(viewModel: DetailViewModel(coin: dev.coin))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            DetailStatsView(viewModel: DetailViewModel(coin: dev.coin))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}