//
//  BinanceCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/02.
//

import Foundation

struct BinanceService {
    static func fetchCoins() async throws -> [BinanceCoin] {
        let baseUrl = "https://api.binance.com/api/v3"
        let url = URL(string: "\(baseUrl)/exchangeInfo")!
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NSError(domain: "Server Error", code: 0, userInfo: nil)
            }
            
            let binanceExchangeInfo = try JSONDecoder().decode(BinanceExchangeInfo.self, from: data)
            let filteredSymbols = binanceExchangeInfo.symbols.filter { $0.quoteAsset == "USDT" && $0.status == "TRADING" }
            let binanceCoins = filteredSymbols.map { BinanceCoin(symbol: $0.symbol, baseAsset: $0.baseAsset, quoteAsset: $0.quoteAsset, status: $0.status) }
            
            return binanceCoins
        } catch {
            print("DEBUG: BinanceCoinDataService.fetchCoins() failed. \(error.localizedDescription)")
            throw error
        }
    }
}


