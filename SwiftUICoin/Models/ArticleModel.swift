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
    let imageUrl: String
    
    init(id: UUID = UUID(), url: String,title: String, date: String, author: String, imageUrl: String) {
        self.id = id
        self.url = url
        self.title = title
        self.date = date
        self.author = author
        self.imageUrl = imageUrl
    }
    
    var image: String {
        let urlString = imageUrl
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    var cleanDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        
        if date.count == 21 {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 a h:mm"
        } else {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh:mm"
        }
        
        guard let convertDate = dateFormatter.date(from: date) else { return date }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.unitsStyle = .short
        formatter.dateTimeStyle = .numeric
        
        return formatter.localizedString(for: convertDate, relativeTo: Date())
    }
}
