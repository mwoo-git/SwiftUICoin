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

class TrendScraperUtility {
    
    func scrapSymbol(from data:Data) -> Future<[TrendModel], Never> {
        Future { promise in
            let html = String(data: data, encoding: .utf8) ?? ""
            var symbols = [TrendModel]()
            do {
                let elements = try SwiftSoup.parse(html)
                let documents = try elements.getElementById("__next")?.select("div > div.main-content > div > div > div > div> table > tbody > tr")
                documents?.forEach({ (document) in
                    let symbol = try? document.select("td > a > div > div > div > p").text().lowercased()
                    
                    if let symbol = symbol, !symbol.isEmpty {
                        
                        let coinsSymbol = TrendModel(symbol: symbol)
                        symbols.append(coinsSymbol)
                        
                    }
                    
                })
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

