//
//  HTMLScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation
import SwiftSoup

struct BlockmediaScraper {
    static func scrapeArticles(from data: Data) async throws -> [ArticleModel] {
        let html = String(decoding: data, as: UTF8.self)
        do {
            let elements = try SwiftSoup.parse(html)
            let articles = try elements.getElementById("content-area")?
                .select("div.paginated_content article")
                .compactMap { article -> ArticleModel in
                    let postContent = try article.select("div.post-content")
                    let url = try postContent.select("h2 a").attr("href")
                    let title = try postContent.select("h2 a").text()
                    let date = try postContent.select("div.post-meta.vcard span").text()
                    let author = try postContent.select("div.post-meta.vcard a.url.fn").text()
                    let imageUrl = try article.select("div.header a img").attr("src")
                    return ArticleModel(url: url, title: title, date: date, author: author, imageUrl: imageUrl)
                }
            return articles ?? []
        } catch let error {
            print("DEBUG: BlockmediaScraper.scrapeArticles() failed. \(error)")
            throw error
        }
    }
}



