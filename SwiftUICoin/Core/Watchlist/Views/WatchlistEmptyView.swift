//
//  WatchlistEmptyView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/17.
//

import SwiftUI

struct WatchlistEmptyView: View {
    var body: some View {
        VStack {
            Text("관심 목록에 코인이 없습니다.")
            NavigationLink(
                destination: SearchView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("코인 추가하기")
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .foregroundColor(Color.theme.textColor)
                    .contentShape(Rectangle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.textColor, lineWidth: 1)
                    )
                }
        }
        .frame(height: UIScreen.main.bounds.height / 1.35)
    }
}

struct WatchlistEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistEmptyView()
    }
}
