//
//  ArticleView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/13.
//

import SwiftUI
import Kingfisher

struct ArticleView: View {
    
    let article: ArticleModel
    
    var body: some View {
        VStack(spacing: 0) {
            topColumn
            rowColumn
        }
        .contentShape(Rectangle())
        .padding()
        .frame(height: 140)
        .foregroundColor(Color.theme.accent)
    }
}

struct AtricleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: dev.article)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
    }
}

extension ArticleView {
    private var topColumn: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("블록미디어")
                        .font(.footnote)
                }
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(Color.theme.textColor)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
            let size = UIScreen.main.bounds.width / 5
            KFImage(URL(string: article.image))
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(7)
                .padding(.leading)
        }
    }
    
    private var rowColumn: some View {
        HStack {
            Text(article.cleanDate)
                .font(.footnote)
            Spacer()
        }
    }
}
