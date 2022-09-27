//
//  CommentView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/27.
//

import SwiftUI

struct CommentView: View {
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("댓글")
                    .foregroundColor(Color.white)
                Text("175")
                    .foregroundColor(Color.theme.accent)
                    .font(.subheadline)
                    .padding(.leading, 5)
                Spacer()
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.subheadline)
            }
            HStack {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 28, height: 28)
                Text("비트코인 더 올라갈까요?")
                Spacer()
            }
            .padding(.bottom, 5)
        }
        .padding()
    }
}
//
//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
//}
