//
//  CoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/13.
//

import Foundation

struct CoinGeckoService {
    static func fetchCoins() async throws -> [CoinModel] {
        do {
            let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=24h")!
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NSError(domain: "Server Error", code: 0, userInfo: nil)
            }

            let coins = try JSONDecoder().decode([CoinModel].self, from: data)
            return coins
        } catch {
            print("DEBUG: CoinGeckoService.fetchCoins() failed.")
            throw error
        }
    }
    
    static func fetchCoinDetails(withCoin coin: String) async throws -> CoinDetailModel {
        do {
            let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin)?localization=true&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")!
            
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NSError(domain: "Server Error", code: 0, userInfo: nil)
            }
            
            let coinDetails = try JSONDecoder().decode(CoinDetailModel.self, from: data)
            return coinDetails
        } catch {
            print("DEBUG: CoinGeckoService.fetchCoinDetails() failed.")
            throw error
        }
    }
}
