//
//  SearchListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/17.
//

import SwiftUI

struct SearchListView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.status != .status200 && viewModel.allCoins.isEmpty {
                    ForEach(viewModel.searchCoinsBackup) { backup in
                        NavigationLink(
                            destination: NavigationLazyView(DetailView(coin: nil, backup: backup)),
                            label: { EditCoinRowView(backup: backup) }
                        )
                    }
                } else {
                    ForEach(viewModel.searchCoins) { coin in
                        NavigationLink(
                            destination: NavigationLazyView(DetailView(coin: coin, backup: nil)),
                            label: { EditCoinRowView(coin: coin) }
                        )
                    }
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
