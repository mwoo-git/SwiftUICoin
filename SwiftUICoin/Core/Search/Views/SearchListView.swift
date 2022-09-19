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
                ForEach(viewModel.searchCoins) { coin in
                    CoinRowView(coin: coin)
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
