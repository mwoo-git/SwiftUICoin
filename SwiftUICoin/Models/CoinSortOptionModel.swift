//
//  CoinSortOptionModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/26.
//

import Foundation

enum CoingeckoSortOption: String, CaseIterable, Identifiable {
    case favorite = "FAVORITE"
    case rank = "MARKET_CAP"
    case priceChangePercentage24H = "PRICE_UP"
    case priceChangePercentage24HReversed = "PRICE_DOWN"
    case price = "PRICE"
    case pricereversed = "PRICE_REVERSED"
    
    var id: String { self.rawValue }
}

