//
//  BinanceCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/02.
//

import Foundation
import Combine

class BinanceCoinDataService {
    static let shared = BinanceCoinDataService()
    
    private let baseUrl = "https://api.binance.com/api/v3"
    private let session = URLSession.shared
    
    func fetchCoins(completion: @escaping ([BinanceCoin]?) -> Void) {
        let url = URL(string: "\(baseUrl)/exchangeInfo")!
        print("start binance")
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(BinanceExchangeInfo.self, from: data)
                let coins = response.symbols.filter { $0.quoteAsset == "USDT" && $0.status == "TRADING" }
                    .map { BinanceCoin(symbol: $0.symbol, baseAsset: $0.baseAsset, quoteAsset: $0.quoteAsset, status: $0.status) }
                completion(coins)
                print("end Binance")
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}

struct BinanceExchangeInfo: Codable {
    let symbols: [BinanceCoin]
}
