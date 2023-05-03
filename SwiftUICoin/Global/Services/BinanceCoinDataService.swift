//
//  BinanceCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/02.
//

import Foundation
import Alamofire
import Combine

class BinanceCoinDataService {
    @Published var coins = [BinanceCoin]()
    
    private let baseUrl = "https://api.binance.com/api/v3"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        AF.request("\(baseUrl)/exchangeInfo")
            .validate(statusCode: 200..<300)
            .publishDecodable(type: BinanceExchangeInfo.self, decoder: JSONDecoder())
            .compactMap { $0.value }
            .map { $0.symbols.filter { $0.quoteAsset == "USDT" && $0.status == "TRADING" }
                .map { BinanceCoin(symbol: $0.symbol, baseAsset: $0.baseAsset, quoteAsset: $0.quoteAsset, status: $0.status) }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching binance coins: \(error)")
                case .finished:
                    print("Binance coin data fetching finished.")
                }
            }, receiveValue: { [weak self] coins in
                self?.coins = coins
            })
            .store(in: &cancellables)
    }
}


