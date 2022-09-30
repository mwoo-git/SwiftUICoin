//
//  SearchView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            Divider()
//            listOptionBar
            if !viewModel.searchText.isEmpty {
                SearchListView(viewModel: viewModel)
                    .padding(.top, 10)
            }
            Spacer()
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView()
                .preferredColorScheme(.dark)
            SearchView()
                .preferredColorScheme(.dark)
        }
    }
}

extension SearchView {
    
    private var searchBar: some View {
        HStack {
            SearchBarView(searchText: $viewModel.searchText)
            Spacer()
            Text("취소")
                .foregroundColor(Color.theme.textColor)
                .font(.subheadline)
                .padding(.leading, 5)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .padding()
        .padding(.bottom, -8)
    }
    
    private var listOptionBar: some View {
        HStack(alignment: .top, spacing: 30) {
            VStack() {
                Text("Markets")
                    .foregroundColor(Color.white)
                Capsule()
                    .fill(Color.theme.binanceColor)
                    .frame(width: 25, height: 3)
            }
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
    }
}
