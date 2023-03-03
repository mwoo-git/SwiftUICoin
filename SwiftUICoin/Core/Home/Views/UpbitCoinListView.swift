//
//  UpbitCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI

struct UpbitCoinListView: View {
    
    @EnvironmentObject var vm: UpbitCoinViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                Button {
                    vm.showTickers.toggle()
                } label: {
                    Text(vm.showTickers ? "시작" : "정지")
                }

                ForEach(vm.displayedTickers) { ticker in
                    UpbitCoinRowView(ticker: ticker)
                }
            }
        }
        .onAppear {
            vm.showTickers = true
        }
        .onDisappear {
            vm.showTickers = false
        }
    }
}

struct UpbitCoinListView_Previews: PreviewProvider {
    static var previews: some View {
        UpbitCoinListView()
    }
}
