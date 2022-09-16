//
//  AllCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//

import SwiftUI

struct AllCoinListView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.allCoins) { coin in
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

//struct AllCoinListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllCoinListView()
//    }
//}
