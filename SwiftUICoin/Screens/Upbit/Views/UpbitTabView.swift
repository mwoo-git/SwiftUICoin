//
//  UpbitTabView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/17.
//

import SwiftUI

struct UpbitTabView: View {
    
    @StateObject private var vm = UpbitViewModel()
    
    var body: some View {
        TabView {
            UpbitListView(tickers: vm.volume, coins: vm.coins)
            UpbitListView(tickers: vm.winners, coins: vm.coins)
            UpbitListView(tickers: vm.lossers, coins: vm.coins)
        }
        .onAppear {
            vm.reload()
        }
        .onDisappear {
            vm.webSocketService.close()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct UpbitTabView_Previews: PreviewProvider {
    static var previews: some View {
        UpbitTabView()
    }
}
