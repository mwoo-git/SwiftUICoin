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
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader {proxyReader in
            RefreshableScrollView(loadingViewBackgroundColor: Color.theme.background, onRefresh: { done in
                if !viewModel.isLoading {
                    viewModel.getCoin()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    done()
                }
            }) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: VStack(spacing: 0) {
                        SortOptionView()
                    }) {
                        ForEach(viewModel.allCoins) { coin in
                            NavigationLink(
                                destination: NavigationLazyView(DetailView(coin: coin)),
                                label: {
                                    CoinRowView(coin: coin)
                                })
                                .buttonStyle(ListSelectionStyle())
                        }
                    }
                }
                .id("SCROLL_TO_TOP")
                .overlay(scrollToTopGeometryReader)
            }
            .background(Color.theme.background)
            .overlay(
                scrollToTopButton
                    .onTapGesture {
                        withAnimation {
                            proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                        }
                    }
                ,alignment: .bottomTrailing
            )
            .onAppear {
                UIScrollView.appearance().keyboardDismissMode = .onDrag
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
            .opacity(-scrollViewOffset > 145 ? 1: 0)
    }
}

