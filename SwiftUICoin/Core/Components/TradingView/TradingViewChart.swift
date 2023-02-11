//
//  TradingView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/15.
//

import SwiftUI
import WebKit

struct TradingViewChart: View {
    
    let symbol: String
    @State private var html = ""
    
    var body: some View {
        WebView(html: $html)
            .onAppear {
                self.loadHTML()
            }
    }
    
    private func loadHTML() {
        let meta = "<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, viewport-fit=cover'>"
        let style = "<style>body { margin: 0; background-color: #131722; } .container { width: 100vw; height: 100vh; }</style>"
        let tradingView = """
        <div class="tradingview-widget-container">
          <div id="tradingview_e8bc1"></div>
          <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
          <script type="text/javascript">
            new TradingView.widget({
              "autosize": true,
              "symbol": "\(symbol)",
              "interval": "D",
              "timezone": "Etc/UTC",
              "theme": "dark",
              "style": "1",
              "logscale": true,
              "scale": "log",
              "locale": "en",
              "toolbar_bg": "#131722",
              "enable_publishing": false,
              "allow_symbol_change": true,
              "scalesProperties.priceScaleProperties.mode": "log",
              "studies_overrides": {
                "moving average.ma.color": "#A62CB0"
              },
              "studies": [
                { id: "MASimple@tv-basicstudies", inputs: { length: 25 } },
                { id: "MASimple@tv-basicstudies", inputs: { length: 99 } },
                { id: "MASimple@tv-basicstudies", inputs: { length: 7 } },
                { id: "Volume@tv-basicstudies" }
              ],
              "container_id": "tradingview_e8bc1"
            });
          </script>
        </div>
        """
        
        html = "<html><head>\(meta)\(style)</head><body>\(tradingView)</body></html>"
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
