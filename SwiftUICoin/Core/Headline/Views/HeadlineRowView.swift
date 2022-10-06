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

struct HeadlineRowView_Previews: PreviewProvider {
    static var previews: some View {
            HeadlineRowView(headline: dev.headline)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
    }
}

extension HeadlineRowView {
    private var topColumn: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    KFImage(URL(string: headline.authorImageUrl))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .cornerRadius(5)
                    Text(headline.author.replacingOccurrences(of: "언론사 선정", with: ""))
                        .font(.footnote)
                        .padding(.leading, 5)
                }
                Text(headline.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(Color.theme.textColor)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
            let size = UIScreen.main.bounds.width / 5
            KFImage(URL(string: headline.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(7)
        }
    }
    
    private var rowColumn: some View {
        HStack {
            Text(headline.date)
                .font(.footnote)
            Spacer()
            Image(systemName: "ellipsis")
        }
    }
}
