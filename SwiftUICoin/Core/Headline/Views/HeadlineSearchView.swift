//
//  HeadlineSearchView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/11.
//

import SwiftUI

struct HeadlineSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var keyword = ""
    @State private var didReturn = false
    @State private var refreshList = false
    @Binding var didChange: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            Divider()
            if keyword.isEmpty {
                Spacer()
            } else {
                if refreshList {
                    HeadlineListView(keyword: keyword)
                } else {
                    HeadlineListView(keyword: keyword)
                }
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .onChange(of: didReturn) { _ in
            keyword = searchText
            refreshList.toggle()
        }
    }
}

struct HeadlineSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineSearchView(didChange: .constant(false))
    }
}

private extension HeadlineSearchView {
    var searchBar: some View {
        HStack {
            SearchBarView(searchText: $searchText, didReturn: $didReturn)
            Spacer()
            Text("취소")
                .foregroundColor(Color.theme.textColor)
                .font(.subheadline)
                .padding(.leading, 5)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    presentationMode.wrappedValue.dismiss()
                    self.searchText = ""
                }
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
        .padding()
        .padding(.bottom, -8)
    }
}
