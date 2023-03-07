//
//  TradingViewViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/05.
//

import SwiftUI
import WebKit
import Combine

class TradingViewViewModel: ObservableObject {
    @Published var symbol: String = ""
    @Published var html: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    init(symbol: String) {
        self.symbol = symbol
        self.loadHTML()
        self.$symbol
            .sink { [weak self] _ in
                self?.loadHTML()
            }
            .store(in: &cancellables)
    }
    
    func loadHTML() {
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
    
}
