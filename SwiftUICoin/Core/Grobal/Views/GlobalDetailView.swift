//
//  GlobalDetailView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/11/01.
//

import SwiftUI

struct GlobalDetailView: View {
    
    let symbol: String
    let name: String
    
    var body: some View {
        VStack(spacing: 0) {
            TradingView(symbol: symbol)
            header
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct GlobalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalDetailView(symbol: "NASDAQ:META", name: "메타")
    }
}

private extension GlobalDetailView {
    var header: some View {
        HStack(spacing: 0) {
            BackButtonView()
            HStack {
                Text(name)
                    .bold()
            }
            Spacer()
        }
        .background(Color.theme.coinDetailBackground.ignoresSafeArea())
        .frame(width: UIScreen.main.bounds.width)
    }
}
