//
//  BinanceScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/17.
//
import Foundation
import SwiftSoup
import Combine

// Selector
/*
 row: #__next > div > div.main-content > div > div > div > div> table > tbody > tr
 symbol: td:nth-child(2) > div > div > span:nth-child(2)
 */

class TrendScraper {
    
    func scrapeSymbol(from data:Data) -> Future<[TrendModel], Never> {
        Future { promise in
            let html = String(data: data, encoding: .utf8) ?? ""
            var symbols = [TrendModel]()
            do {
                let elements = try SwiftSoup.parse(html)
                let documents = try elements.select("table tbody tr td a div div div p").array()
                symbols = documents.compactMap { try? TrendModel(symbol: $0.text().lowercased()) }
                promise(.success(symbols))
            } catch let error {
                debugPrint(error)
                promise(.success([]))
                return
            }
        }
    }
}
// #__APP > div > main > section:nth-child(4) > div > div > div > div > div.rc-table-body > table > tbody > tr > td > div > div > span:nth-child(2)

