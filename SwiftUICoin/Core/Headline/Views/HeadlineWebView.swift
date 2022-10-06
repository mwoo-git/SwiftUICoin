//
//  HeadlineWebView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import SwiftUI
import WebKit
import Kingfisher

struct HeadlineWebView: View {
    
    let article: HeadlineModel
    
    var body: some View {
        VStack(spacing: 0) {
            webViewHeader
            WebView(url: URL(string: article.url)!)
            
        }
        .onAppear(perform: {
            print(article.url)
        })
        .navigationBarHidden(true)
    }
}

struct HeadlineWebView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineWebView(article: dev.headline)
    }
}

extension HeadlineWebView {
    private var webViewHeader: some View {
        HStack {
            BackButtonView()
            Text(article.title)
                .lineLimit(1)
                .font(.headline)
            Spacer()
            IconView(iconName: "square.and.arrow.up")
        }
        .background(Color.theme.background)
        .frame(width: UIScreen.main.bounds.width)
    }
}


