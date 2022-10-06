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
    let imageUrl: String
    let authorImageUrl: String
    
    init(id: UUID = UUID(), url: String,title: String, date: String, author: String, imageUrl: String, authorImageUrl: String) {
        self.id = id
        self.url = url
        self.title = title
        self.date = date
        self.author = author
        self.imageUrl = imageUrl
        self.authorImageUrl = authorImageUrl
    }
    
    static var headlinePlaceholder = HeadlineModel(url: "http://www.wowtv.co.kr/NewsCenter/News/Read?articleId=A202210040046&amp;t=NN", title: "'부자아빠' 기요사키, 달러 폭락 예언...비트코인·금·은 매수할 때", date: "17시간 전", author: "한국경제TV", imageUrl: "https://search.pstatic.net/common/?src=https%3A%2F%2Fimgnews.pstatic.net%2Fimage%2Forigin%2F215%2F2022%2F10%2F04%2F1057633.jpg&type=ff264_180&expire=2&refresh=true", authorImageUrl: "https://search.pstatic.net/common/?src=https%3A%2F%2Fmimgnews.pstatic.net%2Fimage%2Fupload%2Foffice_logo%2F215%2F2018%2F09%2F18%2Flogo_215_18_20180918133718.png&type=f54_54&expire=24&refresh=true")
    
}
