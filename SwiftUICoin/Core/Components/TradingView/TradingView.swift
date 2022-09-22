//
//  TradingView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/15.
//

import SwiftUI
import WebKit

struct TradingView: View {
    
    let symbol: String
    @State private var html = ""
    
    
    var body: some View {
        
        WebView(html: $html)
            .onAppear {
                html = """
                <html><head>
                <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no,
                    viewport-fit=cover'>
                <style>
                                    body {
                                        margin: 0;
                                        background-color: #1F2630;
                                    }
                                    .container {
                                        width: 100vw;
                                        height: 100vh;
                                        background: pink;
                                    }
                </style>
                </head>
                <body>
                <!-- TradingView Widget BEGIN -->
                <div class="tradingview-widget-container">
                  <div id="tradingview_e8bc1"></div>
                  <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
                  <script type="text/javascript">
                  new TradingView.widget(
                  {
                  "autosize": true,
                  "symbol": "\(symbol)",
                  "interval": "D",
                  "timezone": "Etc/UTC",
                  "theme": "dark",
                  "style": "1",
                  "locale": "en",
                  "toolbar_bg": "#1F2630",
                  "enable_publishing": false,
                  "studies": [
                    "Volume@tv-basicstudies"
                  ],
                  "container_id": "tradingview_e8bc1"
                }
                  );
                  </script>
                </div>
                <!-- TradingView Widget END -->
                </body></html>
                """
            }
    }
    
    struct WebView: UIViewRepresentable {
        @Binding var html: String
        
        func makeUIView(context: Context) -> WKWebView {
            return WKWebView()
        }
        
        func updateUIView(_ webView: WKWebView, context: Context) {
            webView.loadHTMLString(html, baseURL: nil)
            webView.scrollView.isScrollEnabled = false
        }
    }
    
    struct TradingView_Previews: PreviewProvider {
        static var previews: some View {
            TradingView(symbol: "BTC")
        }
    }
}
