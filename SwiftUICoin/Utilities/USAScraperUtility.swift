//
//  USAScraperUtility.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/29.
//

import Foundation
import SwiftSoup
import Combine

// Selector
/*
 row: #quotesBoxChartWrp > table > tbody > tr
 name: td:nth-child(2) > a
 price: td:nth-child(3)
 priceChange: td:nth-child(4)
 priceChanePercentage: td:nth-child(5)
 */

class USAScraperUtility {
    
    func scrapGlobal(from data:Data) -> Future<[GlobalModel], Never> {
        Future { promise in
            let html = String(data: data, encoding: .utf8) ?? ""
            var globals = [GlobalModel]()
            do {
                let elements = try SwiftSoup.parse(html)
                let documents = try elements.getElementById("quotesBoxChartWrp")?.select("table > tbody > tr")
                documents?.forEach({ (document) in
                    
                    let name = try? document.select("td:nth-child(2) > a").text()
                    let price = try? document.select("td:nth-child(3)").text()
                    let priceChange = try? document.select("td:nth-child(4)").text()
                    let priceChangePercentage = try? document.select("td:nth-child(5)").text()
    
                    if let name = name,
                       let price = price,
                       let priceChange = priceChange,
                       let priceChangePercentage = priceChangePercentage,
                       
                       !name.isEmpty,
                       !price.isEmpty,
                       !priceChange.isEmpty,
                       !priceChangePercentage.isEmpty {
                        
                        let globalItem = GlobalModel(name: name, price: price, priceChange: priceChange, priceChangePercentage: priceChangePercentage)
                        globals.append(globalItem)
                        
                    }
                    
                })
                promise(.success(globals))
            } catch let error {
                debugPrint(error)
                promise(.success([]))
                return
            }
        }
    }
}
// #__APP > div > main > section:nth-child(4) > div > div > div > div > div.rc-table-body > table > tbody > tr > td > div > div > span:nth-child(2)

