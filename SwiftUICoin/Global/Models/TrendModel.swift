//
//  BinanceModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/17.
//

import Foundation

struct TrendModel: Codable, Identifiable {
    var id: UUID
    let symbol: String
    
    init(id: UUID = UUID(), symbol: String) {
        self.id = id
        self.symbol = symbol
    }
}
