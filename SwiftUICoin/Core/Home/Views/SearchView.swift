//
//  SearchView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                searchBar
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
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
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .padding()
    }
    
}
