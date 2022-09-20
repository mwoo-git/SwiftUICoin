//
//  SearchListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/17.
//

import SwiftUI

struct SearchListView: View {
    
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.searchCoins) { coin in
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
