//
//  ArticleDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation

struct BlockMediaService {
    static func fetchArticles(withCoin coin: CoinModel ) async throws -> [ArticleModel] {
        let symbol = coin.symbol.convertSymbol
        let urlString = "https://www.blockmedia.co.kr/?s=\(symbol)"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let articles = try await BlockmediaScraper.scrapeArticles(from: data)
            return articles
        } catch {
            print("DEBUG: BlockMediaService.fetchArticles() failed. \(error.localizedDescription)")
            throw error
        }
    }
}
