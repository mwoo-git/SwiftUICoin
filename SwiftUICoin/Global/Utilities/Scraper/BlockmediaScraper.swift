//
//  HTMLScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation
import SwiftSoup
import Combine

class BlockmediaScraper {    
    func scrapeArticles(from data: Data) -> Future<[ArticleModel], Never> {
        Future { promise in
            let html = String(data: data, encoding: .utf8) ?? ""
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
                promise(.success(articles ?? []))
            } catch let error {
                debugPrint(error)
                promise(.success([]))
            }
        }
    }
}



