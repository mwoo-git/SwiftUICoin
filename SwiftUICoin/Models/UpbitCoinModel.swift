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

struct UpbitTicker: Codable {
    let market: String
    let tradePrice: Double
    let signedChangeRate: Double
    let accTradeVolume: Double

    enum CodingKeys: String, CodingKey {
        case market
        case tradePrice = "trade_price"
        case signedChangeRate = "signed_change_rate"
        case accTradeVolume = "acc_trade_volume"
    }
}
