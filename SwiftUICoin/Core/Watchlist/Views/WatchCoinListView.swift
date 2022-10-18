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
            viewModel.getCoin()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                done()
                viewModel.loadWatchlist()
            }
        }) {
            if viewModel.allCoins.isEmpty || viewModel.allCoins.isEmpty && viewModel.backupCoins.isEmpty {
                
                VStack {
                    ForEach(0..<5) { i in
                        CoinPlaceholderView()
                    }
                }
                
            } else {
                if viewModel.status != .status200 && viewModel.allCoins.isEmpty {
                    
                    backupCoins
                    
                } else {
                    
                    mainCoins
                    
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

extension WatchCoinListView {
    private var mainCoins: some View {
        LazyVStack {
            if viewModel.status == .status429 || viewModel.status == .status500 {
                StatusErrorView()
            }
            if viewModel.isWatchlistEmpty() && viewModel.mainWatchlist.isEmpty {
                WatchlistEmptyView()
            } else {
                ForEach(viewModel.mainWatchlist) { coin in
                    if !viewModel.isEditing {
                        NavigationLink(
                            destination: NavigationLazyView(DetailView(coin: coin, backup: nil)),
                            label: { CoinRowView(coin: coin, backup: nil)
                                
                            })
                            .onAppear {
                                viewModel.loadWatchlist()
                            }
                    } else {
                        EditCoinRowView(coin: coin, backup: nil)
                    }
                }
            }
        }
    }
    
    private var backupCoins: some View {
        LazyVStack {
            if viewModel.status == .status429 || viewModel.status == .status500 {
                StatusErrorView()
            }
            if viewModel.isWatchlistEmpty() && viewModel.mainWatchlist.isEmpty {
                WatchlistEmptyView()
            } else {
                ForEach(viewModel.mainWatchlistBackup) { backup in
                    if !viewModel.isEditing {
                        NavigationLink(
                            destination: NavigationLazyView(DetailView(coin: nil, backup: backup)),
                            label: { CoinRowView(coin: nil, backup: backup) })
                            .onAppear {
                                viewModel.loadWatchlist()
                            }
                    } else {
                        EditCoinRowView(coin: nil, backup: backup)
                    }
                }
            }
        }
    }
}
