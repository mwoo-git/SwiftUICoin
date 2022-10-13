//
//  WebView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/24.
//

import SwiftUI
import WebKit
import Kingfisher

struct ArticleWebView: View {
    
    let article: ArticleModel
    
    var body: some View {
        VStack(spacing: 0) {
            webViewHeader
            WebView(url: URL(string: article.url)!)
        }
        .navigationBarHidden(true)
    }
}

struct ArticleWebView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleWebView(article: dev.article)
    }
}

extension ArticleWebView {
    private var webViewHeader: some View {
        HStack {
            BackButtonView()
            Text(article.title)
                .lineLimit(1)
                .font(.headline)
            Spacer()
            IconView(iconName: "square.and.arrow.up")
        }
        .background(Color.theme.coinDetailBackground
                        .ignoresSafeArea())
        .frame(width: UIScreen.main.bounds.width)
    }
}


