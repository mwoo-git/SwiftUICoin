//
//  GlobalScrollView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/01/22.
//

import SwiftUI

struct GlobalScrollView: View {
    
    @EnvironmentObject var UpbitVm: UpbitCoinViewModel
    @StateObject var viewModel: GlobalViewModel
    @State private var isScrolling = false
    @State private var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        Group {
            if viewModel.indices.isEmpty {
                placeholder
            } else {
                scrollView
            }
        }
        .onChange(of: isScrolling) { newValue in
            if isScrolling {
                print("Scrolling in progress")
                UpbitVm.isTimerRunning = false
            } else {
                print("Scrolling has stopped")
                UpbitVm.isTimerRunning = true
            }
        }
    }
}

struct GlobalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalScrollView(viewModel: GlobalViewModel())
            .previewLayout(.sizeThatFits)
    }
}

private extension GlobalScrollView {
    var placeholder: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(0..<6) {_ in
                    GlobalPlaceholderView()
                }
            }
        }
        .padding(.leading)
    }
    
    var scrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.indices) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView2(global: item)
                        })
                }
                ForEach(viewModel.commodities) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView2(global: item)
                        })
                }
                ForEach(viewModel.stocks) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView2(global: item)
                        })
                }
            }
            .overlay(listGeometryReader)
        }
        .padding(.leading)
    }
    
    var listGeometryReader: some View {
        GeometryReader { proxy -> Color in
            let newOffset = proxy.frame(in: .named("scrollView")).minX
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
