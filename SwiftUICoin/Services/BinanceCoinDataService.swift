//
//  BinanceCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/02.
//

import Foundation
import Combine

class BinanceCoinDataService {
    @Published var coins = [BinanceCoin]()
    
    private let baseUrl = "https://api.binance.com/api/v3"
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        self.fetchCoinsPublisher()
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
    
    private func fetchCoinsPublisher() -> AnyPublisher<[BinanceCoin], Error> {
        let url = URL(string: "\(baseUrl)/exchangeInfo")!
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: BinanceExchangeInfo.self, decoder: JSONDecoder())
            .map { $0.symbols.filter { $0.quoteAsset == "USDT" && $0.status == "TRADING" }
                .map { BinanceCoin(symbol: $0.symbol, baseAsset: $0.baseAsset, quoteAsset: $0.quoteAsset, status: $0.status) }
            }
            .eraseToAnyPublisher()
    }
}


