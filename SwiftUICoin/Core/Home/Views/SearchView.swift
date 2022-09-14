//
//  SearchView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @Binding var showSearchView: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                searchBar
                listOptionBar
                AllCoinListView(viewModel: viewModel)
                    .padding(.top, 10)
                Spacer(minLength: 0)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(showSearchView: .constant(true))
            .preferredColorScheme(.dark)
    }
}

extension SearchView {
    
    private var searchBar: some View {
        HStack {
            SearchBarView(searchText: $viewModel.searchText)
                .frame(width: 320)
            Spacer()
            Text("Cancel")
                .foregroundColor(Color.theme.binanceColor)
                .font(.subheadline)
                .onTapGesture {
                    withAnimation {
                        showSearchView.toggle()
                    }
                }
        }
        .padding()
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
