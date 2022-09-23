//
//  CoinDetailNewsDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation
import Combine

class ArticleDataService {
    @Published var articles: [ArticleModel] = []
    
    var htmlScrapUtlity = HTMLScraperUtility()
    var cancellableTask: AnyCancellable? = nil
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinNews()
    }
    
    private func getCoinNews() {
        
        guard let url = URL(string: "https://www.blockmedia.co.kr/?s=\(coin.symbol)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        print(request)
        self.cancellableTask?.cancel() //cancel last subscription to prevent race condition
        self.cancellableTask = URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data) //extract Data() from tuple
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

