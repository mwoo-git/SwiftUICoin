//
//  BinanceDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/17.
//
import Foundation

struct CoinMarketCapService {
    static func fetchTrends() async throws -> [TrendModel] {
        let urlString = "https://coinmarketcap.com/ko/trending-cryptocurrencies/"
        let url = URL(string: urlString)!
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NSError(domain: "Server Error", code: 0, userInfo: nil)
            }
            
            let trend = try await TrendScraper.scrapeTrend(from: data)
            return trend
        } catch {
            print("DEBUG: TrendDataService.fetchTrends() failed. \(error.localizedDescription)")
            throw error
        }
    }
}

