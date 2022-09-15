//
//  TradingView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/15.
//

import SwiftUI
import WebKit

struct TradingView: View {
    
    @State private var html = ""
    
    var body: some View {
        VStack {
            
            if html.isEmpty {
            Text("HTML is Empty")
                    .frame(width: UIScreen.main.bounds.width, height: 700, alignment: .center)
                    .background(Color.gray)
            } else {
                WebView(html: $html)
                    .frame(height: 700)
            }
            changeButton
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
            TradingView()
        }
    }
}

extension TradingView {
    private var changeButton: some View {
        Text("Change")
            .onTapGesture {
                self.html =
                """
                    <html>
                    <head>
                        <meta name='viewport' content='initial-scale=1, viewport-fit=cover'>
                        <style>
                            body {
                                margin: 0;
                            }

                            .container {
                                width: 100vw;
                                height: 100vh;
                                background: pink;
                            }
                        </style>
                    </head>
                    <body style='background: white;'>
                        <!-- TradingView Widget BEGIN -->
                        <div class="tradingview-widget-container">
                            <div id="tradingview_fe825">
                            </div>
                            <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
                            <script type="text/javascript">
                                new TradingView.widget({
                                    "autosize": true,
                                    "symbol": "\("BTC")USDT",
                                    "interval": "D",
                                    "timezone": "Etc/UTC",
                                    "theme": "dark",
                                    "style": "1",
                                    "locale": "en",
                                    "toolbar_bg": "#f1f3f6",
                                    "enable_publishing": false,
                                    "allow_symbol_change": true,
                                    "studies": [{
                                            id: "MASimple@tv-basicstudies",
                                            inputs: {
                                                length: 7
                                            }
                                        },
                                        {
                                            id: "MASimple@tv-basicstudies",
                                            inputs: {
                                                length: 25
                                            }
                                        },
                                        {
                                            id: "MASimple@tv-basicstudies",
                                            inputs: {
                                                length: 99
                                            }
                                        },
                                        {
                                            id: "Volume@tv-basicstudies"
                                        }
                                    ],
                                    "container_id": "tradingview_a345a"
                                });
                            </script>
                        </div>
                        <!-- TradingView Widget END -->
                    </body>
                    </html>
                """
            }
    }
}
