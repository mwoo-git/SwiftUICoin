//
//  HeadlineListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/06.
//

import SwiftUI
import SwiftUIPullToRefresh
import BetterSafariView

struct HeadlineListView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var viewModel: HeadlineViewModel
    @State private var showSafari = false
    @State private var url = ""
    
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
                        Button {
                            if url != article.url {
                                url = article.url
                            } else {
                                showSafari.toggle()
                            }
                        } label: {
                            HeadlineRowView(headline: article)
                        }
                        .buttonStyle(ListSelectionStyle())
                    }
                }
                .padding(.top)
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
                        .preferredBarAccentColor(isDarkMode ? .black : .white)
                        .preferredControlAccentColor(isDarkMode ? .white : .black)
                        .dismissButtonStyle(.done)
                }
            }
        }
        .onAppear {
            if !viewModel.articles.isEmpty {
                viewModel.getArticle()
            }
        }
    }
}

struct HeadlineListView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineListView(keyword: "비트코인")
    }
}
