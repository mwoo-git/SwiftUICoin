//
//  HeadlineScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation
import SwiftSoup

struct HeadlineScraper {
    static func scrapeHeadlines(from data: Data) async throws -> [HeadlineModel] {
        let html = String(data: data, encoding: .utf8) ?? ""
        do {
            let elements = try SwiftSoup.parse(html)
            let mainPack = try elements.getElementById("main_pack")
            let headlines = try mainPack?
                    .select("section.sc_new.sp_nnews._prs_nws > div > div.group_news > ul > li > div.news_wrap.api_ani_send")
                    .compactMap { document -> HeadlineModel in
                        let url = try document.select("div > a[href].news_tit").attr("href")
                        let title = try document.select("div > a[href].news_tit").text()
                        let date = try document.select("div > div.news_info > div.info_group > span").text()
                        let author = try document.select("div > div.news_info > div.info_group > a.info.press").text()
                        let authorImageUrl = try document.select("div > div.news_info > div.info_group > a.info.press > span > img").attr("src")
                        return HeadlineModel(url: url, title: title, date: date, author: author, authorImageUrl: authorImageUrl)
                    }
            
            return headlines ?? []
        } catch let error {
            print("DEBUG: HeadlineScraper.scrapeHeadlines() failed. \(error.localizedDescription)")
            throw error
        }
    }
}

// Selector
/*
 
 row: #main_pack > section.sc_new.sp_nnews._prs_nws > div > div.group_news > ul > li > div.news_wrap.api_ani_send
 url, title: div > a[href].news_tit
 date: div > div.news_info > div.info_group > span
 author: div > div.news_info > div.info_group > a.info.press
 imageUrl: a > img[src].api_get
 authorImageUrl: div > div.news_info > div.info_group > a.info.press > span > img
 
 */
