//
//  SortOptionBarView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/19.
//

import SwiftUI

struct SortOptionView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    
                    button(for: .favorite, label: "관심목록")
                        .padding(.leading, 6)
                    
                    Divider()
                    
                    button(for: .rank, label: "시가총액")
                        .overlay(selectedBorder(for: .rank), alignment: .bottom)
                        .cornerRadius(50)
                    
                    button(for: .priceChangePercentage24H, label: "상승")
                        .overlay(selectedBorder(for: .priceChangePercentage24H), alignment: .bottom)
                        .cornerRadius(50)
                    
                    button(for: .priceChangePercentage24HReversed, label: "하락")
                        .overlay(selectedBorder(for: .priceChangePercentage24HReversed), alignment: .bottom)
                        .cornerRadius(50)
                }
                .font(.system(size: 15, weight: .regular))
                .onAppear {
                    self.scrollViewProxy = proxy
                }
                .padding(.horizontal, 10) // Add horizontal padding to HStack
            }
            .padding(.bottom, 8)
            .background(Color.theme.background)
        }
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

private extension SortOptionView {
    func button(for sortOption: SortOption, label: String) -> some View {
        let isSelected = viewModel.sortOption == sortOption
        
        return Button(action: {
            if viewModel.sortOption != sortOption {
                viewModel.sortOption = sortOption
            }
            
            withAnimation(.easeInOut) {
                scrollViewProxy?.scrollTo(sortOption, anchor: .topLeading)
            }
        }, label: {
            if sortOption == .favorite {
                HStack(spacing: 5) {
                    Image(systemName: viewModel.sortOption != .favorite ? "star" : "star.fill")
                        .foregroundColor(viewModel.sortOption != .favorite ? .theme.textColor : .theme.binanceColor)
                    Text(label)
                        .foregroundColor(Color.theme.textColor)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 13)
                .padding(.leading, -6)
                .background(Color.theme.sortOptionColor)
                .cornerRadius(3)
            } else {
                HStack {
                    Text(label)
                        .foregroundColor(isSelected ? Color.theme.background : Color.theme.textColor)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 13)
                .background(isSelected ? Color.theme.textColor : Color.theme.sortOptionColor)
                .cornerRadius(3)
            }
            
        })
            .id(sortOption)
    }
    
    func selectedBorder(for sortOption: SortOption) -> some View {
        let isSelected = viewModel.sortOption == sortOption
        
        return RoundedRectangle(cornerRadius: 50)
            .stroke(isSelected ? Color.theme.background : Color(.systemGray4), lineWidth: 3)
    }
}
