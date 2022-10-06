//
//  HeadlineDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation
import Combine

class HeadlineDataService {
    
    @Published var articles: [HeadlineModel] = []
    
    var htmlScrapUtlity = HeadlineScraperUtility()
    var cancellableTask: AnyCancellable? = nil
    var keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
        getArticles()
    }
    
    func getArticles() {
        
        let urlString = "https://search.naver.com/search.naver?where=news&sm=tab_jum&query=\(keyword)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedString) else { return print("scrap url error")}
        print("start \(keyword) scrap")
        self.cancellableTask?.cancel()
        self.cancellableTask = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtlity.scrapArticle(from:))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
            } receiveValue: { [weak self] (articles) in
                self?.articles = articles
                print("scrap end")
            }
    }
    
    deinit {
        cancellableTask = nil
    }
}
