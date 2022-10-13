//
//  CoinWebView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/24.
//

//
//  CoinWebView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/24.
//

import SwiftUI
import WebKit
import Kingfisher

struct CoinWebView: View {

    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            header
            WebView(url: URL(string: viewModel.websiteURL ?? "")!)
        }
        .navigationBarHidden(true)
    }
}

struct CoinWebView_Previews: PreviewProvider {
    static var previews: some View {
        CoinWebView(viewModel: DetailViewModel(coin: dev.coin, backup: nil))
    }
}

extension CoinWebView {
    private var header: some View {
        HStack {
            BackButtonView()
            Spacer()
            HStack {
                KFImage(URL(string: (viewModel.coin?.image ?? viewModel.backup?.image) ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                Text((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "")
                    .bold()
            }
            Spacer()
            IconView(iconName: "square.and.arrow.up")
        }
        .background(Color.theme.coinDetailBackground.ignoresSafeArea())
        .frame(width: UIScreen.main.bounds.width)
    }
}

