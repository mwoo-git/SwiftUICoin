//
//  ArticleDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation
import Combine

class BlockmediaDataService {
    @Published var articles = [ArticleModel]()
    
    private let htmlScrapUtility = BlockmediaScraper()
    private var coinSubscription: AnyCancellable?
    
    private let coin: CoinModel?
    private let backup: BackupCoinEntity?
    
    init(coin: CoinModel? = nil, backup: BackupCoinEntity? = nil) {
        self.coin = coin
        self.backup = backup
        
        getArticles()
    }
    
    private func getArticles() {
        let symbol = coin?.symbol.convertSymbol ?? backup?.symbol?.convertSymbol ?? ""
        let urlString = "https://www.blockmedia.co.kr/?s=\(symbol)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtility.scrapeArticles(from:))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] (articles) in
                self?.articles = articles
                self?.coinSubscription?.cancel()
                print("Scrap end")
            })
    }
}
