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
    @Environment(\.presentationMode) var presentationMode
    
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
            IconView(iconName: "arrow.left")
                .onTapGesture {
                    withAnimation() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            Text(article.title)
                .lineLimit(1)
                .font(.headline)
            Spacer()
            IconView(iconName: "square.and.arrow.up")
        }
        .background(Color.theme.coinDetailBackground)
        .frame(width: UIScreen.main.bounds.width)
    }
}


