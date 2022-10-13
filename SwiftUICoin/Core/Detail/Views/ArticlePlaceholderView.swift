//
//  ArticlePlaceholderView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/04.
//

import SwiftUI
import Kingfisher

struct ArticlePlaceholderView: View {
    
    @State private var opacity: Double = 1
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(0..<4) { i in
                VStack(spacing: 0) {
                    topColumn
                    rowColumn
                }
                .padding()
                .frame(height: 140)
                .foregroundColor(Color.theme.accent)
                .redacted(reason: .placeholder)
            }
            Spacer()
        }
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
        ArticlePlaceholderView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
    }
}

extension ArticlePlaceholderView {
    private var topColumn: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("한국경제TV...".replacingOccurrences(of: "언론사 선정", with: ""))
                        .font(.footnote)
                }
                Text("'부자아빠' 기요사키, 달러 폭락 예언...비트코인·금·은 매수할 때'부자아빠' 기요사키, 달러 폭락 예언...비트코인·금·은 매수할 때")
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
            let size = UIScreen.main.bounds.width / 5
            KFImage(URL(string: "https://search.pstatic.net/common/?src=https%3A%2F%2Fmimgnews.pstatic.net%2Fimage%2Fupload%2Foffice_logo%2F215%2F2018%2F09%2F18%2Flogo_215_18_20180918133718.png&type=f54_54&expire=24&refresh=true"))
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(7)
                .padding(.leading)
        }
    }
    
    private var rowColumn: some View {
        HStack {
            Text("17시간 전...")
            Spacer()
        }
        .font(.footnote)
    }
}

