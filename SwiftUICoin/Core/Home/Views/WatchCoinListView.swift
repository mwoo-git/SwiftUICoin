//
//  WatchCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/26.
//

import SwiftUI

struct WatchCoinListView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView() {
            LazyVStack {
                ForEach(viewModel.reloadWatchCoins) { coin in
                    NavigationLink(
                        destination: NavigationLazyView(DetailView(coin: coin)),
                        label: { CoinRowView(coin: coin) }
                    )
                }
            }
        }
        .onAppear {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
            viewModel.reloadWatchlist()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct WatchCoinListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchCoinListView()
    }
}
