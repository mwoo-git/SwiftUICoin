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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
        CoinWebView(viewModel: DetailViewModel(coin: dev.coin))
    }
}

extension CoinWebView {
    private var header: some View {
        HStack {
            IconView(iconName: "arrow.left")
                .onTapGesture {
                    withAnimation() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            Spacer()
            HStack {
                KFImage(URL(string: viewModel.coin.image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                Text(viewModel.coin.symbol.uppercased())
                    .bold()
            }
            Spacer()
            IconView(iconName: "square.and.arrow.up")
        }
        .background(Color.theme.coinDetailBackground)
        .frame(width: UIScreen.main.bounds.width)
    }
}

