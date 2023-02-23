//
//  SearchView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var didReturn = false
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            Divider()
            if !viewModel.searchText.isEmpty {
                SearchListView()
                    .padding(.top, 10)
            } else {
                SearchAllCoinsView()
                    .padding(.top, 10)
            }
            Spacer()
        }
        .onAppear {
            viewModel.sortOption = .rank
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

private extension SearchView {
    
    var searchBar: some View {
        HStack {
            SearchBarView(searchText: $viewModel.searchText, didReturn: $didReturn)
            Spacer()
            Text("취소")
                .foregroundColor(Color.theme.textColor)
                .font(.subheadline)
                .padding(.leading, 5)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    presentationMode.wrappedValue.dismiss()
                    viewModel.searchText = ""
                }
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
        .padding()
        .padding(.bottom, -8)
    }
}
