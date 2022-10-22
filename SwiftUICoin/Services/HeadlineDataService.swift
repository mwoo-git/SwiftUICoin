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
    var coinSubscription: AnyCancellable?
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
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtlity.scrapArticle(from:))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (articles) in
                self?.articles = articles
                print("scrap end")
                self?.coinSubscription?.cancel()
            }
    }
}