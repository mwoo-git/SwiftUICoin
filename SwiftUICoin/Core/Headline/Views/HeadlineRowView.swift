//
//  HeadlineRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import SwiftUI
import Kingfisher

struct HeadlineRowView: View {
    
    let headline: HeadlineModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                KFImage(URL(string: headline.authorImageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .cornerRadius(5)
                Text(headline.cleanAuthor)
                    .font(.footnote)
                    .padding(.leading, 5)
            }
            .padding(.bottom, 10)
            Text(headline.title)
                .font(.title3)
                .lineLimit(2)
                .foregroundColor(Color.theme.textColor)
                .multilineTextAlignment(.leading)
            Spacer()
            HStack {
                Text(headline.cleanDate)
                    .font(.footnote)
                Spacer()
                Image(systemName: "ellipsis")
            }
        }
        .contentShape(Rectangle())
        .padding()
        .frame(height: 140)
        .foregroundColor(Color.theme.accent)
    }
}

struct HeadlineRowView_Previews: PreviewProvider {
    static var previews: some View {
            HeadlineRowView(headline: dev.headline)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
    }
}
