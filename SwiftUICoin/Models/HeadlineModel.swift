//
//  HeadlineModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation

struct HeadlineModel: Codable, Identifiable {
    var id: UUID
    let url: String
    let title: String
    let date: String
    let author: String
    let authorImageUrl: String
    
    init(id: UUID = UUID(), url: String,title: String, date: String, author: String, authorImageUrl: String) {
        self.id = id
        self.url = url
        self.title = title
        self.date = date
        self.author = author
        self.authorImageUrl = authorImageUrl
    }
    
    var cleanAuthor: String {
        return author.replacingOccurrences(of: "언론사 선정", with: "")
    }
    
    var cleanDate: String {
        if date.count >= 7 {
           return date
                .suffix(6)
                .trimmingCharacters(in: CharacterSet(charactersIn: "단"))
                .trimmingCharacters(in: CharacterSet(charactersIn: " "))
        } else {
            return date
        }
    }
}


