//
//  UpbitCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation
import Alamofire
import Combine
import Starscream

class UpbitRestApiService {
    
    static let shared = UpbitRestApiService()
    
    @Published var coins = [UpbitCoin]()
    @Published var tickers = [String: UpbitTicker]()
    
    private let baseUrl = "https://api.upbit.com/v1"
    private var coinCancellables = Set<AnyCancellable>()
    private var tickerCancellables = Set<AnyCancellable>()
    
    private init() {
        fetchCoins()
    }
    
    private func fetchCoins() {
        AF.request("\(baseUrl)/market/all")
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [UpbitCoin].self, decoder: JSONDecoder())
            .compactMap { $0.value }
            .map { $0.filter { $0.market.hasPrefix("KRW") } }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching upbit coins: \(error)")
                case .finished:
                    print("Upbit coin data fetching finished.")
                    self.fetchTickers()
                }
            }, receiveValue: { [weak self] coins in
                self?.coins = coins
            })
            .store(in: &coinCancellables)
    }
    
    private func fetchTickers() {
        let tickersUrl = "https://api.upbit.com/v1/ticker?markets=" + coins.map { $0.market }.joined(separator: ",")
        
        AF.request(tickersUrl)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [UpbitTickerRestAPI].self, decoder: JSONDecoder())
            .compactMap { $0.value }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching upbit tickers: \(error)")
                    case .finished:
                        print("Upbit ticker data fetching finished.")
                    }
                },
                receiveValue: { [weak self] tickers in
                        var tickersDict: [String: UpbitTicker] = [:]
                        tickers.forEach { tickerRestAPI in
                            let ticker = UpbitTicker(market: tickerRestAPI.market,
                                                     change: tickerRestAPI.change,
                                                     tradePrice: tickerRestAPI.tradePrice,
                                                     changeRate: tickerRestAPI.changeRate,
                                                     accTradePrice24H: tickerRestAPI.accTradePrice24H,
                                                     signedChangeRate: tickerRestAPI.signedChangeRate)
                            tickersDict[ticker.market] = ticker
                        }
                        self?.tickers = tickersDict
                    }
            )
            .store(in: &tickerCancellables)
    }
}
