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
            VStack(alignment: .leading) {
                Text("나스닥 100")
                Text("11,191.630")
                    .font(.title2)
                    .bold()
                HStack {
                    Text("▾214.27")
                    Text("-1.88%")
                }
                .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
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
