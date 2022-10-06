//
//  HeadlineListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/06.
//

import SwiftUI
import SwiftUIPullToRefresh

struct HeadlineListView: View {
    
    @StateObject var viewModel: HeadlineViewModel
    
    init(keyword: String) {
        _viewModel = StateObject(wrappedValue: HeadlineViewModel(keyword: keyword))
    }
    
    var body: some View {
        RefreshableScrollView(showsIndicators: false, loadingViewBackgroundColor: Color.theme.background, onRefresh: { done in
            viewModel.getArticle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                done()
            }
        }) {
            if viewModel.articles.isEmpty {
                HeadlinePlaceholderView()
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(viewModel.articles) { article in
                        NavigationLink(
                            destination: NavigationLazyView(HeadlineWebView(article: article)),
                            label: {
                                HeadlineRowView(headline: article)
                            })
                            .buttonStyle(ListSelectionStyle())
                    }
                }.padding(.top)
            }
        }
    }
}

struct HeadlineListView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineListView(keyword: "비트코인")
    }
}
