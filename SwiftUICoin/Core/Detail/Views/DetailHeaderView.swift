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
                Image(systemName: homeViewModel.isWatchlistExists(coin: viewModel.backup?.symbol ?? "") ? "star.fill" : "star")
                    .foregroundColor(homeViewModel.isWatchlistExists(coin: viewModel.backup?.symbol ?? "") ? Color.theme.binanceColor : Color.theme.accent)
                    .padding()
                    .onTapGesture {
                        homeViewModel.updateWatchlist(coin: viewModel.backup?.symbol ?? "")
                    }
            } else {
                Image(systemName: homeViewModel.isWatchlistExists(coin: viewModel.coin?.symbol ?? "") ? "star.fill" : "star")
                    .foregroundColor(homeViewModel.isWatchlistExists(coin: viewModel.coin?.symbol ?? "") ? Color.theme.binanceColor : Color.theme.accent)
                    .padding()
                    .onTapGesture {
                        homeViewModel.updateWatchlist(coin: viewModel.coin?.symbol ?? "")
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
