//
//  HeadlinePlaceholderView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/07.
//

import SwiftUI
import Kingfisher

struct HeadlinePlaceholderView: View {
    
    @State private var opacity: Double = 1
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(0..<5) { i in
                row
            }
            Spacer()
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

struct HeadlinePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlinePlaceholderView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

private extension HeadlinePlaceholderView {
    var row: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("한국경제TV....")
                    .font(.footnote)
            }
            .padding(.bottom, 10)
            Text("'부자아빠' 기요사키, 달러 폭락 예언...비트코인·금·은 매수할 때'부자아빠' 기요사키, 달러 폭락 예언..")
                .font(.title3)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Spacer()
            HStack {
                Text("17시간 전...")
                    .font(.footnote)
                Spacer()
                Text("...")
            }
        }
        .contentShape(Rectangle())
        .padding()
        .frame(height: 140)
        .foregroundColor(Color.theme.accent)
        .redacted(reason: .placeholder)
    }
}

