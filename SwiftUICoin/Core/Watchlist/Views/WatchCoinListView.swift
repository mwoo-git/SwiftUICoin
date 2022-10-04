//
//  WatchCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/26.
//

import SwiftUI
import SwiftUIPullToRefresh

struct WatchCoinListView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        RefreshableScrollView(loadingViewBackgroundColor: Color.theme.background, onRefresh: { done in
            if !viewModel.isRefreshing {
                viewModel.getCoin()
                viewModel.isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    viewModel.isRefreshing = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                done()
            }
        }) {
            if viewModel.allCoins.isEmpty {
                LazyVStack {
                    ForEach(0..<5) { i in
                        CoinPlaceholderView()
                    }
                }
            } else {
                if !viewModel.isEditing {
                    LazyVStack {
                        ForEach(viewModel.mainWatchlist) { coin in
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
                        ForEach(viewModel.mainWatchlist) { coin in
                            EditCoinRowView(coin: coin)
                        }
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
