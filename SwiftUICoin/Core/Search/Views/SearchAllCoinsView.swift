//
//  SearchAllCoinsView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/13.
//

import SwiftUI

struct SearchAllCoinsView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.status != .status200 && viewModel.allCoins.isEmpty {
                    ForEach(viewModel.backupCoins) { backup in
                        NavigationLink(
                            destination: NavigationLazyView(DetailView(coin: nil, backup: backup)),
                            label: { EditCoinRowView(backup: backup) }
                        )
                    }
                } else {
                    ForEach(viewModel.allCoins) { coin in
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
