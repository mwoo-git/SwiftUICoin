//
//  HTMLScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation
import SwiftSoup
import Combine

class HTMLScraperUtility {
    
    func scrapArticle(from data:Data) -> Future<[ArticleModel], Never> {
        Future { promise in
            let html = String(data: data, encoding: .utf8)!
            var articles = [ArticleModel]()
            do {
                let elements = try SwiftSoup.parse(html)
    
                let documents = try elements.getElementById("content-area")?.select("div.et_pb_extra_column_main").select("div").select("div.paginated_content").select("div").select("div").select("article")
                documents?.forEach({ (document) in
                    let url = try? document.select("div.post-content").select("h2").select("a").attr("href")
                    let title = try? document.select("div.post-content").select("h2").select("a").text()
                    let date = try? document.select("div.post-content").select("div.post-meta.vcard").select("p").select("span").text()
                    let author = try? document.select("div.post-content").select("div.post-meta.vcard").select("p").select("a.url.fn").text()
                    
                    if let url = url,
                       let title = title,
                       let date = date,
                       let author = author,
                       !url.isEmpty,
                       !title.isEmpty,
                       !date.isEmpty,
                       !author.isEmpty {
                        
                        let article = ArticleModel(url: url, title: title, date: date, author: author)
                        articles.append(article)
                    }
                })
                promise(.success(articles))
            } catch let error {
                debugPrint(error)
                promise(.success([]))
                return
            }
        }
    }
}

