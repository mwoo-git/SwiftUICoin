//
//  AllCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.

import SwiftUI
import SwiftUIPullToRefresh

struct HomeCoinListView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @EnvironmentObject var binanceViewModel: BinanceCoinViewModel
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxyReader in
            RefreshableScrollView(loadingViewBackgroundColor: Color.theme.background, onRefresh: { done in
                viewModel.getCoin()
                globalViewModel.fetchGlobalList()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    done()
                }
            }) {
                if viewModel.allCoins.isEmpty && viewModel.backupCoins.isEmpty {
                    VStack(spacing: 0) {
                        SortOptionView()
                        LazyVStack {
                            ForEach(0..<5) { i in
                                CoinPlaceholderView()
                            }
                        }
                    }
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        GlobalScrollView(viewModel: globalViewModel)
                        allCoinList
                    }
                    .id("scrollView")
                }
            }
            .overlay(
                scrollToTopButton
                    .onTapGesture {
                        withAnimation {
                            proxyReader.scrollTo("scrollView", anchor: .top)
                        }
                    }
                ,alignment: .bottomTrailing
            )
            .background(Color.theme.background)
            .onAppear {
                UIScrollView.appearance().keyboardDismissMode = .onDrag
                if !viewModel.allCoins.isEmpty || !viewModel.backupCoins.isEmpty {
                    viewModel.getCoin()
                    globalViewModel.fetchGlobalList()
                }
            }
            .onChange(of: viewModel.sortOption) { _ in
                if viewModel.sortOption == .favorite {
                    proxyReader.scrollTo("scrollView", anchor: .top)
                }
            }
        }
    }
}

struct AllCoinListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCoinListView()
            .preferredColorScheme(.dark)
    }
}

private extension HomeCoinListView {
    var allCoinList: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header: VStack(spacing: 0) {
                SortOptionView()
            }) {
                if viewModel.status == .status429 || viewModel.status == .status500 {
                    StatusErrorView()
                }
                if viewModel.sortOption == .favorite {
                    WatchCoinListView()
                } else {
                    if viewModel.status != .status200 && viewModel.allCoins.isEmpty {
                        ForEach(viewModel.backupCoins) { backup in
                            NavigationLink(
                                destination: NavigationLazyView(DetailView(coin: nil, backup: backup)),
                                label: {
                                    CoinRowView(coin: nil, backup: backup)
                                })
                                .buttonStyle(ListSelectionStyle())
                        }
                    } else {
                        ForEach(binanceViewModel.binanceCoins(allCoins: viewModel.allCoins, binanceCoins: binanceViewModel.coins)) { coin in
                            NavigationLink(
                                destination: NavigationLazyView(DetailView(coin: coin, backup: nil)),
                                label: {
                                    CoinRowView(coin: coin, backup: nil)
                                })
                                .buttonStyle(ListSelectionStyle())
                        }
                    }
                }
            }
        }
        .overlay(scrollToTopGeometryReader)
    }
    
    var scrollToTopGeometryReader: some View {
        GeometryReader { proxy -> Color in
            let offsetY = proxy.frame(in: .named("scrollView")).minY
            let newOffset = max(0, offsetY)
            if self.scrollViewOffset != newOffset {
                DispatchQueue.main.async {
                    self.scrollViewOffset = newOffset
                }
            }
            return Color.clear
        }
    }
    
    var scrollToTopButton: some View {
        Image(systemName: "arrow.up")
            .font(.title2)
            .foregroundColor(Color.white)
            .frame(width: 40, height: 40)
            .background(Circle().foregroundColor(Color.theme.arrowButton))
            .padding(.trailing, 30)
            .padding(.bottom, 40)
            .opacity(scrollViewOffset < 80 ? 1 : 0)
    }
}

