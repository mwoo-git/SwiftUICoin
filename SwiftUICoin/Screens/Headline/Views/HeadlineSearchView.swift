//
//  HeadlineSearchView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/11.
//

import SwiftUI

struct HeadlineSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("categories") private var categories = ["비트코인", "이더리움", "증시", "연준", "금리", "환율", "NFT", "메타버스"]
    @AppStorage("searchHistory") private var searchHistory: [String] = []
    @Binding var didChange: Bool
    @State private var searchText = ""
    @State private var keyword = ""
    @State private var didReturn = false
    @State private var refreshList = false
    @State private var isFocus = false
    @State private var message = ""
    @State private var showMessage = false
    
    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            if keyword.isEmpty || isFocus {
                if !searchText.isEmpty {
                    searchButton
                } else {
                    searchHistoryList
                }
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(keyword)
                                .font(.title3)
                                .bold()
                            Spacer()
                            Button(action: exists() ? delete : add) {
                                Image(systemName: "star.circle")
                                    .foregroundColor(exists() ? Color.theme.binanceColor : Color.theme.textColor)
                                    .contentShape(Rectangle())
                                    .font(.title2)
                            }
                        }
                        .padding()
                        if refreshList {
                            HeadlineListView(keyword: keyword)
                        } else {
                            HeadlineListView(keyword: keyword)
                        }
                    }
                }
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .onChange(of: didReturn) { _ in
            search()
        }
        .overlay(messageView, alignment: .bottom)
        .colorScheme(.dark)
    }
}

struct HeadlineSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineSearchView(didChange: .constant(false))
    }
}

private extension HeadlineSearchView {
    var header: some View {
        HStack {
            SearchBarView(searchText: $searchText, didReturn: $didReturn, isFocus: $isFocus)
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
    
    var searchButton: some View {
        Button {
            didReturn.toggle()
        } label: {
            HStack(spacing: 25) {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                Text(searchText)
                Spacer()
            }
            .foregroundColor(Color.theme.textColor)
            .padding()
            .contentShape(Rectangle())
        }
    }
    
    func search() {
        if !searchText.isEmpty {
            keyword = searchText
            addSearchHistory()
        }
        refreshList.toggle()
        UIApplication.shared.endEditing()
    }
    
    func exists() -> Bool {
        categories.contains(keyword)
    }
    
    func add() {
        categories.insert(keyword, at: 0)
        didChange.toggle()
        showMessageView(message: "\(keyword)을(를) 팔로우 중입니다.")
    }
    
    func delete() {
        categories.removeAll(where: { $0 == keyword })
        didChange.toggle()
        showMessageView(message: "\(keyword) 팔로우를 해제하였습니다")
    }
    
    var messageView: some View {
        VStack() {
            if showMessage {
                Text(message)
                    .foregroundColor(Color.theme.background)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.theme.textColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.1))
            }
        }
    }
    
    func showMessageView(message: String) {
        self.message = message
        self.showMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showMessage = false
        }
    }
    
    var searchHistoryList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(searchHistory, id: \.self) { item in
                Button {
                    keyword = item
                    didReturn.toggle()
                } label: {
                    HStack {
                        HStack(spacing: 25) {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                            Text(item)
                        }
                        .foregroundColor(Color.theme.textColor)
                        Spacer()
                        Button(action: {
                            if let index = searchHistory.firstIndex(of: item) {
                                deleteSearchHistory(at: IndexSet(integer: index))
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                        })
                    }
                    .contentShape(Rectangle())
                    .padding()
                }
            }
        }
    }
    
    func containsInSearchHistory() -> Bool {
        searchHistory.contains(keyword)
    }
    
    func addSearchHistory() {
        if let index = searchHistory.firstIndex(of: keyword) {
            searchHistory.remove(at: index)
        }
        searchHistory.insert(keyword, at: 0)
        if searchHistory.count > 5 {
            searchHistory.removeLast()
        }
    }
    
    func deleteSearchHistory(at indexSet: IndexSet) {
        searchHistory.remove(atOffsets: indexSet)
    }
}
