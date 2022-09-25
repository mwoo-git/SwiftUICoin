//
//  ArticleListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import SwiftUI

struct ArticleListView: View {
    
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(viewModel.articles) { article in
                NavigationLink(destination: NavigationLazyView(ArticleWebView(article: article))) {
                    ArticleView(article: article)
                }
            }
        }
        .padding(.top)
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(viewModel: DetailViewModel(coin: dev.coin))
            .preferredColorScheme(.dark)
    }
}
