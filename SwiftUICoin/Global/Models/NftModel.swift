//
//  NftModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/25.
//

import Foundation

struct NftModel: Codable, Identifiable {
    var id: UUID
    let rank: String
    let url: String
    let image: String
    let name: String
    let floorPrice: String
    let volume: String
    let volumeChangePercentage: String
    
    init(id: UUID = UUID(), rank: String, url: String, image: String, name: String, floorPrice: String, volume: String, volumeChangePercentage: String) {
        self.id = id
        self.rank = rank
        self.url = url
        self.image = image
        self.name = name
        self.floorPrice = floorPrice
        self.volume = volume
        self.volumeChangePercentage = volumeChangePercentage
    }
}
