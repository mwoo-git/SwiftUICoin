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
            UpbitListView(tickers: vm.volume)
            UpbitListView(tickers: vm.winners)
            UpbitListView(tickers: vm.lossers)
        }
        .onAppear {
            print("리스트 보여짐")
            vm.webSocketService.connect()
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
