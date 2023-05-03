//
//  GlobalPlaceholderView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/11/01.
//

import SwiftUI

struct GlobalPlaceholderView: View {
    
    @State private var opacity: Double = 1
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text("나스닥 100")
                    .bold()
                Text("-1.88%000")
                    .bold()
                Text("-1.88%0000")
                    .bold()
                    .padding(.trailing, 11)
                    .padding(.vertical, 3)
                    .font(.footnote)
                    .cornerRadius(5)
            }
            .font(.subheadline)
            .contentShape(Rectangle())
            .padding(.vertical, 10)
            Spacer()
        }
        .frame(width: 110)
        .redacted(reason: .placeholder)
        .opacity(opacity)
        .onAppear {
            withAnimation {
                opacity = 0.2
            }
        }
        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: opacity)
    }
}

struct GlobalPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalPlaceholderView()
    }
}
