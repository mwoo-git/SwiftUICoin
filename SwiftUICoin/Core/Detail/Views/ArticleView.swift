//
//  ArticleView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import SwiftUI

struct ArticleView: View {
    
    let article: ArticleModel
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 0) {
                Text(article.title)
                    .foregroundColor(Color.theme.textColor)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack(alignment: .firstTextBaseline) {
                    Text(article.author)
                    Text("｜")
                    Text(article.date)
                    Spacer()
                }
                .foregroundColor(Color.theme.accent)
                .font(.subheadline)
            }
            .frame(height: 90)
            .padding(.horizontal)
            .padding(.vertical, 5)
            Divider()
                .padding(.horizontal)
                .padding(.bottom, 5)
                .foregroundColor(Color.theme.accent)
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: dev.article)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
