//
//  UpbitCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI
import UIKit

struct UpbitCoinListView: View {
    
    @StateObject private var vm = UpbitCoinViewModel()
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView() {
                LazyVStack(spacing: 0) {
                    ForEach(Array(vm.displayedTickers.enumerated()), id: \.element) { index, ticker in
                        UpbitCoinRowView(ticker: ticker)
                    }
                    .onAppear {
                        print("리스트 보여짐")
                        vm.webSocketService.connect()
                        
                    }
                    .onDisappear {
                        vm.webSocketService.close()
                    }
                }
                .overlay(ListGeometryReader)
            }
        }
//        .onChange(of: isScrolling) { newValue in
//            if isScrolling {
//                print("Scrolling in progress")
//                vm.send1()
//            } else {
//                print("Scrolling has stopped")
//                vm.send(send: "KRW-BTC")
//            }
//        }
    }
}

struct UpbitCoinListView_Previews: PreviewProvider {
    static var previews: some View {
        UpbitCoinListView()
    }
}

private extension UpbitCoinListView {
    var ListGeometryReader: some View {
        GeometryReader { proxy -> Color in
            let offsetY = proxy.frame(in: .named("scrollView")).minY
            let newOffset = min(0, offsetY)
            if vm.scrollViewOffset != newOffset {
                DispatchQueue.main.async {
                    vm.isScrolling = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    vm.scrollViewOffset = newOffset
                }
            } else {
                DispatchQueue.main.async {
                    vm.isScrolling = false
                }
            }
            return Color.clear
        }
    }
}
