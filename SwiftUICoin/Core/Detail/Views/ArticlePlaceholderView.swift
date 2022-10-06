//
//  ArticlePlaceholderView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/04.
//

import SwiftUI

struct ArticlePlaceholderView: View {
    
    @State private var opacity: Double = 1
    
    var body: some View {
        LazyVStack {
            ForEach(0..<5) { i in
                row
            }
        }
        .padding(.top)
        .opacity(opacity)
        .onAppear {
            withAnimation {
                opacity = 0.2
            }
        }
        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: opacity)
    }
}

struct ArticlePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticlePlaceholderView()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            ArticlePlaceholderView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension ArticlePlaceholderView {
    private var row: some View {
        VStack{
            VStack(alignment: .leading, spacing: 0) {
                Text("article.titlearticle.titlearticle.titlearticle.titlearticle.title")
                    .foregroundColor(Color.theme.textColor)
                    .multilineTextAlignment(.leading)
                    .frame(width: UIScreen.main.bounds.width / 1.2)
                Spacer()
                HStack(alignment: .firstTextBaseline) {
                    Text("Coinness")
                    Text("｜")
                    Text("2022년 9월 22일 오후 12:25")
                    Spacer()
                }
                .font(.subheadline)
            }
            .frame(height: 90)
            .padding(.horizontal)
            .padding(.vertical, 5)
            Divider()
                .padding(.horizontal)
                .padding(.bottom, 5)
        }
        .redacted(reason: .placeholder)
        .foregroundColor(Color.theme.accent)
    }
}
