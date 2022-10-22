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
            Text("+ 를 눌러 추가해보세요.")
        }
        .frame(height: UIScreen.main.bounds.height / 1.35)
    }
}

struct WatchlistEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistEmptyView()
    }
}
