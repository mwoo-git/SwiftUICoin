//
//  SearchBarView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        
        HStack(spacing: 0) {
            IconView(iconName: "magnifyingglass")
                .padding(.vertical, -10)
                .padding(.horizontal, -5)
            
            TextField("Search", text: $searchText)
                .foregroundColor(Color.white)
                // Cursor color
                .accentColor(Color.theme.binanceColor)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .foregroundColor(Color.theme.iconColor)
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0.0 : 0.5)
                        .onTapGesture {
                            searchText = ""
                        }
                    , alignment: .trailing
                )
        }
        .background(Color.theme.searchBar)
        .cornerRadius(25)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            SearchBarView(searchText: .constant(""))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}
