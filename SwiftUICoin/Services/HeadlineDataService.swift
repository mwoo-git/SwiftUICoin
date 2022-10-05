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
    
    init() {
        getArticles()
    }
    
    func getArticles() {
        
        guard let url = URL(string: "https://search.naver.com/search.naver?where=news&sm=tab_jum&query=%EB%B9%84%ED%8A%B8%EC%BD%94%EC%9D%B8") else { return print("scrap url error")}
        print("start scrap")
        self.cancellableTask?.cancel()
        self.cancellableTask = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtlity.scrapArticle(from:))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
            } receiveValue: { [weak self] (articles) in
                self?.articles = articles
            }
    }
    
    deinit {
        cancellableTask = nil
    }
}
