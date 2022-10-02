//
//  WatchCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/26.
//

import SwiftUI
import SwiftUIPullToRefresh

struct WatchCoinListView: View {
    
    @EnvironmentObject var viewModel: WatchlistViewModel
    
    var body: some View {
        RefreshableScrollView(loadingViewBackgroundColor: Color.theme.background, onRefresh: { done in
            if !viewModel.isLoading {
                viewModel.getCoin()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                done()
            }
        }) {
            if !viewModel.isEditing {
                LazyVStack {
                    ForEach(viewModel.loadWatchCoins) { coin in
                        NavigationLink(
                            destination: NavigationLazyView(DetailView(coin: coin)),
                            label: { CoinRowView(coin: coin) }
                        )
                    }
                }
                .onAppear {
                    viewModel.loadWatchlist()
                }
            } else {
                LazyVStack {
                    ForEach(viewModel.loadWatchCoins) { coin in
                        EditCoinRowView(coin: coin)
                    }
                }
            }
        }
        .onAppear {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
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
