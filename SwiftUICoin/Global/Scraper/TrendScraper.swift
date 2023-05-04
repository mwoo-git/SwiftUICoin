//
//  BinanceScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/17.
//
import Foundation
import SwiftSoup

struct TrendScraper {
    static func scrapeTrend(from data: Data) async throws -> [TrendModel] {
        let html = String(data: data, encoding: .utf8) ?? ""
        var symbols = [TrendModel]()
        do {
            let elements = try SwiftSoup.parse(html)
            let documents = try elements.select("table tbody tr td a div div div p").array()
            symbols = documents.compactMap { try? TrendModel(symbol: $0.text().lowercased()) }
            return symbols
        } catch let error {
            print("DEBUG: TrendScraper.scrapeTrend() failed. \(error.localizedDescription)")
            throw error
        }
    }
}

// Selector
/*
 row: #__next > div > div.main-content > div > div > div > div> table > tbody > tr
 symbol: td:nth-child(2) > div > div > span:nth-child(2)
 */

