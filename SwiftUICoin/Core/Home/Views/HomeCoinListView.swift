//
//  AllCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//  LazyStack은 iOS 14이상부터 지원합니다.

import SwiftUI
import SwiftUIPullToRefresh

struct HomeCoinListView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader {proxyReader in
            RefreshableScrollView(loadingViewBackgroundColor: Color.theme.background, onRefresh: { done in
                viewModel.getCoin()
                globalViewModel.fetchGlobalList()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    done()
                }
            }) {
                if viewModel.allCoins.isEmpty || viewModel.allCoins.isEmpty && viewModel.backupCoins.isEmpty {
                    VStack(spacing: 0) {
                        SortOptionView()
                        LazyVStack {
                            ForEach(0..<5) { i in
                                CoinPlaceholderView()
                            }
                        }
                    }
                } else {
                    LazyVStack(alignment: .leading) {
                        GlobalScrollView(viewModel: globalViewModel)
                        Text("코인 순위")
                            .font(.title3)
                            .bold()
                            .padding()
                            .padding(.top, 10)
                        allCoinList
                    }
                    .id("SCROLL_TO_TOP")
                }
            }
            .overlay(
                scrollToTopButton
                    .onTapGesture {
                        withAnimation {
                            proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                        }
                    }
                ,alignment: .bottomTrailing
            )
            .background(Color.theme.background)
            .onAppear {
                UIScrollView.appearance().keyboardDismissMode = .onDrag
                if !viewModel.allCoins.isEmpty && !globalViewModel.indices.isEmpty {
                    viewModel.getCoin()
                    globalViewModel.fetchGlobalList()
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

extension HomeCoinListView {
    
    private var allCoinList: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header: VStack(spacing: 0) {
                SortOptionView()
            }) {
                if viewModel.status == .status429 || viewModel.status == .status500 {
                    StatusErrorView()
                }
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
                    ForEach(viewModel.allCoins) { coin in
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
        .overlay(scrollToTopGeometryReader)
    }
    
    private var scrollToTopGeometryReader: some View {
        GeometryReader{proxy -> Color in
            DispatchQueue.main.async {
                if startOffset == 0 {
                    self.startOffset = proxy.frame(in: .global).minY
                }
                let offset = proxy.frame(in: .global).minY
                self.scrollViewOffset = offset - startOffset
            }
            return Color.clear
        }
    }
    
    private var scrollToTopButton: some View {
        Image(systemName: "arrow.up")
            .font(.title2)
            .foregroundColor(Color.white)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .foregroundColor(Color.theme.arrowButton)
            )
            .padding(.trailing, 30)
            .padding(.bottom, 40)
            .opacity(-scrollViewOffset > 400 ? 1: 0)
    }
}

