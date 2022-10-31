//
//  HeadlineScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation
import SwiftSoup
import Combine

// Selector
/*
 
 row: #main_pack > section.sc_new.sp_nnews._prs_nws > div > div.group_news > ul > li > div.news_wrap.api_ani_send
 url, title: div > a[href].news_tit
 date: div > div.news_info > div.info_group > span
 author: div > div.news_info > div.info_group > a.info.press
 imageUrl: a > img[src].api_get
 authorImageUrl: div > div.news_info > div.info_group > a.info.press > span > img
 
 */

class HeadlineScraperUtility {
    
    func scrapArticle(from data:Data) -> Future<[HeadlineModel], Never> {
        Future { promise in
            let html = String(data: data, encoding: .utf8) ?? ""
            var articles = [HeadlineModel]()
            do {
                let elements = try SwiftSoup.parse(html)
                let documents = try elements.getElementById("main_pack")?.select("section.sc_new.sp_nnews._prs_nws > div > div.group_news > ul > li > div.news_wrap.api_ani_send")
                documents?.forEach({ (document) in
                    let url = try? document.select("div > a[href].news_tit").attr("href")
                    let title = try? document.select("div > a[href].news_tit").text()
                    let date = try? document.select("div").select("div.news_info").select("div.info_group").select("span").text()
                    let author = try? document.select("div").select("div.news_info").select("div.info_group").select("a.info.press").text()
                    let imageUrl = try? document.select("a").select("img[src].api_get").attr("src")
                    let authorImageUrl = try? document.select("div").select("div.news_info").select("div.info_group").select("a.info.press").select("span").select("img").attr("src")
                    
                    if let url = url,
                       let title = title,
                       let date = date,
                       let author = author,
                       let imageUrl = imageUrl,
                       let authorImageUrl = authorImageUrl,
                       !url.isEmpty,
                       !title.isEmpty,
                       !date.isEmpty,
                       !author.isEmpty,
                       !imageUrl.isEmpty,
                       !authorImageUrl.isEmpty {
                        
                        let article = HeadlineModel(url: url, title: title, date: date, author: author, imageUrl: imageUrl, authorImageUrl: authorImageUrl)
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

