//
//  HeadlineSearchHistoryView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/26.
//

import SwiftUI

struct HeadlineSearchHistoryView: View {
    
    @AppStorage("searchHistory") private var searchHistory: [String] = []
    @Binding var searchText: String
    @Binding var didReturn: Bool
    @Binding var keyword: String
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HeadlineSearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineSearchHistoryView(searchText: .constant(""), didReturn: .constant(false), keyword: .constant(""))
    }
}

private extension HeadlineSearchHistoryView {
    func add() {
        guard !keyword.isEmpty else { return }
        searchHistory.insert(keyword, at: 0)
        searchText = keyword
        didReturn.toggle()
    }
    
    func delete(at indexSet: IndexSet) {
        searchHistory.remove(atOffsets: indexSet)
    }
    
    var searchHistoryList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(searchHistory, id: \.self) { item in
                HStack {
                    Text(item)
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color.theme.textColor)
                    Spacer()
                    Button(action: {
                        if let index = searchHistory.firstIndex(of: item) {
                            delete(at: IndexSet(integer: index))
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .frame(width: 24, height: 24)
                    })
                }
                .padding()
            }
        }
    }
}

