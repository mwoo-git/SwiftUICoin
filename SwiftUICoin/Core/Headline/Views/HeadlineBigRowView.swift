//
//  HeadlineBigRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/07.
//

import SwiftUI
import Kingfisher

struct HeadlineBigRowView: View {
    
    let headline: HeadlineModel
    
    var body: some View {
        VStack(spacing: 10) {
            KFImage(URL(string: headline.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.width / 2.1)
                .cornerRadius(10)
            BottomColumn
        }
        .padding()
        .background(Color.theme.background)
    }
}

struct HeadlineBigRowView_Previews: PreviewProvider {
    static var previews: some View {
            HeadlineBigRowView(headline: dev.headline)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
    }
}

extension HeadlineBigRowView {
    private var BottomColumn: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack() {
                KFImage(URL(string: headline.authorImageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .cornerRadius(5)
                Text(headline.author.replacingOccurrences(of: "언론사 선정", with: ""))
                    .font(.subheadline)
                    .padding(.leading, 5)
            }
            Text(headline.title)
                .font(.title2)
                .lineLimit(2)
                .foregroundColor(Color.theme.textColor)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text(headline.date)
                    .font(.subheadline)
                Spacer()
                Image(systemName: "ellipsis")
            }
        }
        .foregroundColor(Color.theme.accent)
    }
}
