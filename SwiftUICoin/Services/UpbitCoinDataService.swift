//
//  UpbitCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation
import Alamofire
import Combine

class UpbitCoinDataService {
    @Published var coins = [UpbitCoin]()
    @Published var tickers = [UpbitTicker]()
    
    private let baseUrl = "https://api.upbit.com/v1"
    private var coinCancellables = Set<AnyCancellable>()
    private var tickerCancellables = Set<AnyCancellable>()
    
    init() {
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
    
    func fetchTickers() {
        let tickersUrl = "https://api.upbit.com/v1/ticker?markets=" + coins.map { $0.market }.joined(separator: ",")
        
        AF.request(tickersUrl)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [UpbitTicker].self, decoder: JSONDecoder())
            .compactMap { $0.value }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching upbit tickers: \(error)")
                    case .finished:
                        print("Upbit ticker data fetching finished.")
//                        print(self.tickers.first(where: { $0.market == "KRW-BTC" }))
                    }
                },
                receiveValue: { [weak self] tickers in
                    self?.tickers = tickers
                }
            )
            .store(in: &tickerCancellables)
    }
}
