//
//  HeadlineDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation
import Combine

class HeadlineDataService {
    
    @Published var headlines = [HeadlineModel]()
    
    private let htmlScrapUtility = HeadlineScraper()
    private var coinSubscription: AnyCancellable?
    private let keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
        getArticles()
    }
    
    func getArticles() {
        let urlString = "https://search.naver.com/search.naver?where=news&sm=tab_jum&query=\(keyword)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: encodedString) else { return print("scrap url error")}
        print("start \(keyword) scrap")
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtility.scrapeHeadlines(from:))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (articles) in
                self?.headlines = articles
                print("scrap end")
                self?.coinSubscription?.cancel()
            }
    }
}
