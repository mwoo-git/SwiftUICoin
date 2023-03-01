//
//  BinanceCoinModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/02.
//

import Foundation

struct BinanceExchangeInfo: Codable {
    let symbols: [BinanceCoin]
}

struct BinanceCoin: Codable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let status: String
}


