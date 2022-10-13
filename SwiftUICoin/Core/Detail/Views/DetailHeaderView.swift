//
//  DetailHeaderView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/14.
//

import SwiftUI
import Kingfisher

struct DetailHeaderView: View {
    
    @StateObject var viewModel: DetailViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            BackButtonView()
            Spacer()
            HStack() {
                KFImage(URL(string: (viewModel.backup?.image ??  viewModel.coin?.image) ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                Text((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "")
                    .bold()
            }
            Spacer()
            if viewModel.coin == nil {
                Image(systemName: homeViewModel.isWatchlistExists(coin: nil, backup: viewModel.backup) ? "star.fill" : "star")
                    .foregroundColor(homeViewModel.isWatchlistExists(coin: nil, backup: viewModel.backup) ? Color.theme.binanceColor : Color.theme.accent)
                    .padding()
                    .onTapGesture {
                        homeViewModel.updateWatchlist(coin: nil, backup: viewModel.backup)
                    }
            } else {
                Image(systemName: homeViewModel.isWatchlistExists(coin: viewModel.coin, backup: nil) ? "star.fill" : "star")
                    .foregroundColor(homeViewModel.isWatchlistExists(coin: viewModel.coin, backup: nil) ? Color.theme.binanceColor : Color.theme.accent)
                    .padding()
                    .onTapGesture {
                        homeViewModel.updateWatchlist(coin: viewModel.coin, backup: nil)
                    }
            }
        }
        .background(Color.theme.background)

    }
}

//struct DetailHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailHeaderView()
//    }
//}
