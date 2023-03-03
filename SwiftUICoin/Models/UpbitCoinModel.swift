//
//  UpbitCoinModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation

struct UpbitCoin: Codable {
    let market: String
    let korean_name: String
    let english_name: String
}

struct UpbitTicker: Codable, Identifiable {
    let id = UUID()
    let market: String
    let change: String
    let tradePrice: Double
    let changeRate: Double
    let accTradePrice24H: Double
    
    enum CodingKeys: String, CodingKey {
        case market
        case change
        case tradePrice = "trade_price"
        case changeRate = "change_rate"
        case accTradePrice24H = "acc_trade_price_24h"
    }
    
    var formattedTradePrice: String {
        if tradePrice >= 100 {
            let number = NSNumber(value: tradePrice)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            formatter.locale = Locale(identifier: "en_US")
            return formatter.string(from: number) ?? ""
        } else if tradePrice >= 1 {
            return String(format: "%.2f", tradePrice)
        } else {
            return String(format: "%.4f", tradePrice)
        }
    }
    
    var formattedChangeRate: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1
        formatter.percentSymbol = "%"
        let rate = self.changeRate * (self.change == "FALL" ? -1 : 1) * 100 
        return formatter.string(for: rate) ?? ""
    }
    
    var formattedAccTradePrice24H: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = ","
        
        let accTradePriceInMillion = self.accTradePrice24H / 1_000_000
        return formatter.string(from: NSNumber(value: accTradePriceInMillion)) ?? "0"
    }
}


