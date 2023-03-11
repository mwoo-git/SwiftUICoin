//
//  UpbitCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI
import UIKit

struct UpbitCoinListView: View {
    @EnvironmentObject var vm: UpbitCoinViewModel
    @State private var scrollViewOffset: CGFloat = 0
    @State private var isScrolling = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView() {
                LazyVStack(spacing: 0) {
                    ForEach(Array(vm.displayedTickers.enumerated()), id: \.element) { index, ticker in
                        UpbitCoinRowView(ticker: ticker)
                    }
                }
                .overlay(ListGeometryReader)
                .onAppear {
                    vm.connectWebSocket()
                }
                .onDisappear {
                    vm.closeWebSocket()
                }
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
            if self.scrollViewOffset != newOffset {
                DispatchQueue.main.async {
                    isScrolling = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.scrollViewOffset = newOffset
                }
            } else {
                DispatchQueue.main.async {
                    isScrolling = false
                }
            }
            return Color.clear
        }
    }
}
