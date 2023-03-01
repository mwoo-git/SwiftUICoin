//
//  BinanceCoinModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/02.
//

import Foundation

struct BinanceCoin: Codable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let status: String
    
    var name: String {
        return baseAsset.lowercased()
    }
}


