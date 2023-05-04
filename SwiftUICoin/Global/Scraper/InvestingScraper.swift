//
//  USAScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/29.
//

import Foundation
import SwiftSoup

struct InvestingScraper {
    static func scrapeInvesting(from data: Data) async throws -> [GlobalModel] {
        let html = String(data: data, encoding: .utf8) ?? ""
        do {
            let elements = try SwiftSoup.parse(html)
            let documents = try elements.getElementById("quotesBoxChartWrp")?
                .select("table > tbody > tr")
                .compactMap { document -> GlobalModel in
                    let name = try document.select("td:nth-child(2) > a").text()
                    let price = try document.select("td:nth-child(3)").text()
                    let priceChange = try document.select("td:nth-child(4)").text()
                    let priceChangePercentage = try document.select("td:nth-child(5)").text()
                    
                    return GlobalModel(name: name, price: price, priceChange: priceChange, priceChangePercentage: priceChangePercentage)
                }
            return documents ?? []
        } catch let error {
            print("DEBUG: InvestingScraper.scrapeInvesting() failed. \(error.localizedDescription)")
            throw error
        }
    }
}

// Selector
/*
 row: #quotesBoxChartWrp > table > tbody > tr
 name: td:nth-child(2) > a
 price: td:nth-child(3)
 priceChange: td:nth-child(4)
 priceChanePercentage: td:nth-child(5)
 */

