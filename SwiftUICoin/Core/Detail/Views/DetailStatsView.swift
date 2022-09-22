//
//  DetailStatsView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/21.
//

import SwiftUI

struct DetailStatsView: View {
    
    @StateObject var viewMdoel: DetailViewModel
    
    var body: some View {
        VStack {
            ForEach(viewMdoel.statistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
}

struct DetailStatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailStatsView(viewMdoel: DetailViewModel(coin: dev.coin))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            DetailStatsView(viewMdoel: DetailViewModel(coin: dev.coin))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}
