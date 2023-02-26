//
//  SearchBarView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//  TextField First Responder

import SwiftUI
import Combine

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var didReturn: Bool
    @Binding var isFocus: Bool
    @State private var clearTextField = false
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .padding(.vertical, -5)
                .padding(.horizontal, 7)
                .foregroundColor(Color.theme.iconColor)
                .font(.subheadline)
            if !clearTextField {
                firstResponderTextField
            } else {
                firstResponderTextField
            }
        }
        .background(Color.theme.searchBar)
        .cornerRadius(8)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""), didReturn: .constant(false), isFocus: .constant(true))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            SearchBarView(searchText: .constant(""), didReturn: .constant(false), isFocus: .constant(true))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension SearchBarView {
    private var normalTextField: some View {
        TextField("검색", text: $searchText)
            .foregroundColor(Color.white)
            .accentColor(Color.theme.binanceColor)
            .frame(height: 30)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .foregroundColor(Color.theme.iconColor)
            )
    }
    
    private var firstResponderTextField: some View {
        FirstResponderTextField(searchText: $searchText, didReturn: $didReturn, isFocus: $isFocus, placeHolder: "검색")
            .foregroundColor(Color.white)
            .accentColor(Color.theme.textColor)
            .frame(height: 30)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .foregroundColor(Color.theme.iconColor)
                    .offset(x: 10)
                    .opacity(searchText.isEmpty ? 0.0 : 0.5)
                    .onTapGesture {
                        searchText = ""
                        clearTextField.toggle()
                    }
                    .contentShape(Rectangle())
                , alignment: .trailing
            )
    }
}

