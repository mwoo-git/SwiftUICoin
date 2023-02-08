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
    
    var htmlScrapUtlity = BlockmediaScraper()
    var coinSubscription: AnyCancellable?
    
    var coin: CoinModel?
    var backup: BackupCoinEntity?
    
    init(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            self.backup = backup
        } else {
            self.coin = coin
        }
        getArticles()
    }
    
    private func getArticles() {
        
        
        let urlString = "https://www.blockmedia.co.kr/?s=\((coin == nil ? backup?.symbol?.convertSymbol : coin?.symbol.convertSymbol) ?? "")"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: encodedString) else { return }
        print("Start 블록미디어 scrap")
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtlity.scrapeArticles(from:))
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
                self?.coinSubscription?.cancel()
                print("Scrap end")
            }
    }
}

