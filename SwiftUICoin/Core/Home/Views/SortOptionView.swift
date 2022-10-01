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
                    HStack(spacing: 0) {
                        Text("Market Cap")
                            .foregroundColor((viewModel.sortOption == .rank) ? Color.white : Color.theme.accent)
                    }
                    .id("MARKET_CAP")
                    .padding(.vertical, 3)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                            .fill(viewModel.sortOption == .rank ? Color.theme.sortOptionSelected : .clear)
                    )
                    .onTapGesture {
                        viewModel.sortOption = .rank
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("MARKET_CAP", anchor: .topLeading)
                        }
                    }
                    
                    let iconSize = 13
                    
                    HStack(spacing: 0) {
                        Text("Price")
                            .foregroundColor((viewModel.sortOption == .price || viewModel.sortOption == .pricereversed) ? Color.white : Color.theme.accent)
                        Image(systemName: "arrow.down")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(viewModel.sortOption == .price ?  Color.white : viewModel.sortOption == .pricereversed ? Color.theme.background : Color.theme.accent)
                        Image(systemName: "arrow.up")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(viewModel.sortOption == .pricereversed ?  Color.white : viewModel.sortOption == .price ? Color.theme.background : Color.theme.accent)
                    }
                    .padding(.vertical, 3)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .background(
                        Capsule()
                            .fill((viewModel.sortOption == .price || viewModel.sortOption == .pricereversed) ? Color.theme.sortOptionSelected : .clear)
                    )
                    .onTapGesture {
                        viewModel.sortOption = viewModel.sortOption == .price ? .pricereversed : .price
                    }
                    
                    HStack(spacing: 0) {
                        Text("24h Change")
                            .foregroundColor((viewModel.sortOption == .priceChangePercentage24H || viewModel.sortOption == .priceChangePercentage24HReversed) ? Color.white : Color.theme.accent)
                        Image(systemName: "arrow.down")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(viewModel.sortOption == .priceChangePercentage24H ?  Color.white : viewModel.sortOption == .priceChangePercentage24HReversed ? Color.theme.background : Color.theme.accent)
                        Image(systemName: "arrow.up")
                            .font(.system(size: CGFloat(iconSize)))
                            .foregroundColor(viewModel.sortOption == .priceChangePercentage24HReversed ?  Color.white : viewModel.sortOption == .priceChangePercentage24H ? Color.theme.background : Color.theme.accent)
                    }
                    .id("24H_CHANGE")
                    .padding(.vertical, 3)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .background(
                        Capsule()
                            .fill((viewModel.sortOption == .priceChangePercentage24H || viewModel.sortOption == .priceChangePercentage24HReversed) ? Color.theme.sortOptionSelected : .clear)
                    )
                    .onTapGesture {
                        viewModel.sortOption = viewModel.sortOption == .priceChangePercentage24H ? .priceChangePercentage24HReversed : .priceChangePercentage24H
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("24H_CHANGE", anchor: .topTrailing)
                        }
                    }
                }
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.theme.accent)
            }
            
            .padding()
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
