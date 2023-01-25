//
//  SortOptionBarView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/19.
//

import SwiftUI

struct SortOptionView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    
                    let vertical: CGFloat = 5
                    let horizontal: CGFloat = 10
                    
                    HStack(spacing: 0) {
                        Text("관심목록")
                            .foregroundColor((viewModel.sortOption == .favorite) ? Color.white : Color.theme.accent)
                    }
                    .id("FAVORITE")
                    .padding(.vertical, vertical)
                    .padding(.horizontal, horizontal)
                    .background(
                        viewModel.sortOption == .favorite ? Color.theme.sortOptionSelected : .clear
                    )
                    .cornerRadius(3)
                    .onTapGesture {
                        if viewModel.sortOption != .favorite {
                            viewModel.sortOption = .favorite
                        }
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("FAVORITE", anchor: .topLeading)
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Text("시가총액")
                            .foregroundColor((viewModel.sortOption == .rank) ? Color.white : Color.theme.accent)
                    }
                    .id("MARKET_CAP")
                    .padding(.vertical, vertical)
                    .padding(.horizontal, horizontal)
                    .background(
                        viewModel.sortOption == .rank ? Color.theme.sortOptionSelected : .clear
                    )
                    .cornerRadius(3)
                    .onTapGesture {
                        if viewModel.sortOption != .rank {
                            viewModel.sortOption = .rank
                        }
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("MARKET_CAP", anchor: .topLeading)
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Text("상승")
                            .foregroundColor((viewModel.sortOption == .priceChangePercentage24H) ? Color.white : Color.theme.accent)
                    }
                    .id("PRICE_UP")
                    .padding(.vertical, vertical)
                    .padding(.horizontal, horizontal)
                    .background(
                        viewModel.sortOption == .priceChangePercentage24H ? Color.theme.sortOptionSelected : .clear
                    )
                    .cornerRadius(3)
                    .onTapGesture {
                        if viewModel.sortOption != .priceChangePercentage24H {
                            viewModel.sortOption = .priceChangePercentage24H
                        }
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("PRICE_UP", anchor: .topLeading)
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Text("하락")
                            .foregroundColor((viewModel.sortOption == .priceChangePercentage24HReversed) ? Color.white : Color.theme.accent)
                    }
                    .id("PRICE_DOWN")
                    .padding(.vertical, vertical)
                    .padding(.horizontal, horizontal)
                    .background(
                        viewModel.sortOption == .priceChangePercentage24HReversed ? Color.theme.sortOptionSelected : .clear
                    )
                    .cornerRadius(3)
                    .onTapGesture {
                        if viewModel.sortOption != .priceChangePercentage24HReversed {
                            viewModel.sortOption = .priceChangePercentage24HReversed
                        }
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("PRICE_DOWN", anchor: .topLeading)
                        }
                    }
                }
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.theme.accent)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.theme.background)
    }
}

struct SortOptionBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SortOptionView()
                .previewLayout(.sizeThatFits)
            SortOptionView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
