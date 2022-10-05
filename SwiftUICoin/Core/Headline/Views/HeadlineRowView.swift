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
        HStack {
            leftColumn
            Spacer()
            rightColumn
        }
        .padding()
        .frame(height: 150)
        .background(Color.theme.background)
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
    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack() {
                KFImage(URL(string: headline.authorImageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .cornerRadius(5)
                Text(headline.author.replacingOccurrences(of: "언론사 선정", with: ""))
                    .font(.footnote)
                    .padding(.leading, 5)
            }
            Text(headline.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(Color.theme.textColor)
            Text(headline.date)
                .font(.footnote)
                .padding(.top)
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            let size = UIScreen.main.bounds.width / 5
            KFImage(URL(string: headline.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(10)
            Spacer()
                Image(systemName: "ellipsis")
        }
    }
}
