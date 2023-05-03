//
//  UpbitCoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation

struct UpbitRestApiService {
    static func fetchCoins() async throws -> [UpbitCoin] {
        let baseUrl = "https://api.upbit.com/v1"
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
            
            return coins
            
        } catch {
            print("Error fetching upbit coins: \(error)")
            throw error
        }
    }
    
    static func fetchTickers(withCoins coins: [UpbitCoin]) async throws -> [String: UpbitTicker] {
        let tickersUrl = "https://api.upbit.com/v1/ticker?markets=" + coins.map { $0.market }.joined(separator: ",")
        let url = URL(string: tickersUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NSError(domain: "Server Error", code: 0, userInfo: nil)
            }
            
            let tickersRestAPI = try JSONDecoder().decode([UpbitTickerRestAPI].self, from: data)
            var tickersDict: [String: UpbitTicker] = [:]
            tickersRestAPI.forEach { tickerRestAPI in
                let ticker = UpbitTicker(market: tickerRestAPI.market,
                                         change: tickerRestAPI.change,
                                         tradePrice: tickerRestAPI.tradePrice,
                                         changeRate: tickerRestAPI.changeRate,
                                         accTradePrice24H: tickerRestAPI.accTradePrice24H,
                                         signedChangeRate: tickerRestAPI.signedChangeRate)
                tickersDict[ticker.market] = ticker
            }
            
            return tickersDict
            
        } catch {
            print("Error fetching upbit tickers: \(error)")
            throw error
        }
    }
}
