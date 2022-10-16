//
//  DetailInfoView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/14.
//

import SwiftUI

struct DetailInfoView: View {
    
    @StateObject var viewModel: DetailViewModel
    @State private var currentTab: Int = 0
    
    var body: some View {
        LazyVStack(
            pinnedViews: [.sectionHeaders]) {
                Section(header: InfoOptionView(viewModel: viewModel, currentTab: $currentTab)) {
                        TabView(selection: $currentTab) {
                            VStack {
                                if viewModel.articles.isEmpty {
                                    ArticlePlaceholderView()
                                } else {
                                ForEach(viewModel.articles.prefix(4)) { article in
                                    NavigationLink(destination: NavigationLazyView(ArticleWebView(article: article))) {
                                        ArticleRowView(article: article)
                                    }
                                    .buttonStyle(ListSelectionStyle())
                                }
                                Spacer()
                                }
                            }
                            .tag(0)
                            
                            DetailStatsView(viewModel: viewModel).tag(1)
                        }
                        .frame(height: 600)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .background(Color.theme.background)

    }
}

//struct DetailInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailInfoView()
//    }
//}
