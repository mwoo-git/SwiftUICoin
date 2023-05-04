//
//  HeadlineDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation

struct HeadlineService {
    static func fetchArticles(withKeyword keyword: String) async throws -> [HeadlineModel] {
        let urlString = "https://search.naver.com/search.naver?where=news&sm=tab_jum&query=\(keyword)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: encodedString)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let articles = try await HeadlineScraper.scrapeHeadlines(from: data)
            return articles
        } catch {
            print("DEBUG: HeadlineDataService.fetchArticles() failed. \(error.localizedDescription)")
            throw error
        }
    }
}
