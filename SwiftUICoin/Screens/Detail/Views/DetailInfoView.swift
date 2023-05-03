//
//  DetailInfoView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/14.
//

import SwiftUI
import BetterSafariView

struct DetailInfoView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showSafari = false
    @StateObject var viewModel: DetailViewModel
    @State private var currentTab: Int = 0
    @State private var url = ""
    
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
                                    Button {
                                        if url != article.url {
                                            url = article.url
                                        } else {
                                            showSafari.toggle()
                                        }
                                    } label: {
                                        ArticleRowView(article: article)
                                    }
                                    .buttonStyle(ListSelectionStyle())
                                }
                                Spacer()
                            }
                        }
                        .tag(0)
                        .onChange(of: url, perform: {_ in
                            showSafari.toggle()
                        })
                        .safariView(isPresented: $showSafari) {
                            SafariView(
                                url: URL(string: url)!,
                                configuration: SafariView.Configuration(
                                    entersReaderIfAvailable: false,
                                    barCollapsingEnabled: true
                                )
                            )
                                .preferredBarAccentColor(.black)
                                .preferredControlAccentColor(.white)
                                .dismissButtonStyle(.done)
                        }
                        
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
