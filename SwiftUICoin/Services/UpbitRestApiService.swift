//
//  UpbitCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation
import Alamofire
import Combine

class UpbitRestApiService {
    
    static let shared = UpbitRestApiService()
    
    @Published var coins = [UpbitCoin]()
    @Published var tickers = [String: UpbitTicker]()
    
    private let queue = DispatchQueue.global()
    private let baseUrl = "https://api.upbit.com/v1"
    private var coinCancellables = Set<AnyCancellable>()
    private var tickerCancellables = Set<AnyCancellable>()
    
    private init() {
        Task {
            await fetchCoins()
        }
    }
    
    private func fetchCoins() async {
        let url = URL(string: "\(baseUrl)/market/all")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NSError(domain: "Server Error", code: 0, userInfo: nil)
            }
            
            let coins = try JSONDecoder().decode([UpbitCoin].self, from: data)
                .filter { $0.market.hasPrefix("KRW") }
            
            self.coins = coins
            self.fetchTickers()
            self.updateCodes()
            
        } catch {
            print("Error fetching upbit coins: \(error)")
        }
    }
    
    func fetchTickers() {
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
    
    private func updateCodes() {
        queue.async {
            let markets = self.coins.map { $0.market }
            UpbitWebSocketService.shared.codesSubject.send(markets)
        }
    }
}
