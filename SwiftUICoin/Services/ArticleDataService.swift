//
//  ArticleDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation
import Combine

class ArticleDataService {
    @Published var articles: [ArticleModel] = []
    @Published var isLoading: Bool = false
    
    var htmlScrapUtlity = HTMLScraperUtility()
    var cancellableTask: AnyCancellable? = nil
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getArticles()
    }
    
    private func getArticles() {
        
        guard let url = URL(string: "https://www.blockmedia.co.kr/?s=\(coin.symbol)") else { return }
        self.isLoading = true
        self.cancellableTask?.cancel()
        self.cancellableTask = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtlity.scrapArticle(from:))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                self.isLoading = false
            } receiveValue: { [weak self] (articles) in
                self?.articles = articles
            }
    }
    
    deinit {
        cancellableTask = nil
    }
}

