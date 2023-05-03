//
//  TradingView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/15.
//

import SwiftUI
import WebKit

struct TradingViewChart: View {
    
    @ObservedObject var viewModel: TradingViewViewModel
    
    init(symbol: String) {
        viewModel = TradingViewViewModel(symbol: symbol)
    }
    
    var body: some View {
        WebView(html: $viewModel.html)
    }
    
    struct WebView: UIViewRepresentable {
        @Binding var html: String
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.scrollView.isScrollEnabled = false
            webView.isOpaque = false
            return webView
        }
        
        func updateUIView(_ webView: WKWebView, context: Context) {
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    struct TradingView_Previews: PreviewProvider {
        static var previews: some View {
            TradingViewChart(symbol: "BTC")
        }
    }
}
