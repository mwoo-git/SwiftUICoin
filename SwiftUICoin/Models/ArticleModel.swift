//
//  CoinDetailNewsModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation

struct ArticleModel: Codable, Identifiable {
    var id: UUID
    let url: String
    let title: String
    let date: String
    let author: String
    
    init(id: UUID = UUID(), url: String,title: String, date: String, author: String) {
        self.id = id
        self.url = url
        self.title = title
        self.date = date
        self.author = author
    }
}
