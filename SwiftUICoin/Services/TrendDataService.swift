//
//  BinanceDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/17.
//
import Foundation
import Combine

class TrendDataService {
    @Published var trendCoins: [TrendModel] = []
    
    var htmlScrapUtlity = TrendScraperUtility()
    var coinSubscription: AnyCancellable?
    
    init() {
        getArticles()
    }
    
    private func getArticles() {
        
        
        let urlString = "https://coinmarketcap.com/ko/trending-cryptocurrencies/"
        
        guard let url = URL(string: urlString) else { return }
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtlity.scrapSymbol(from:))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (symbols) in
                self?.trendCoins = symbols
                self?.coinSubscription?.cancel()
            }
    }
}

