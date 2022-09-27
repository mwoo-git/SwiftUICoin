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
                ForEach(viewModel.watchlistCoins) { coin in
                    NavigationLink(
                        destination: NavigationLazyView(DetailView(coin: coin)),
                        label: { CoinRowView(coin: coin) }
                    )
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
        }
    }
}

struct WatchCoinListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchCoinListView()
    }
}
