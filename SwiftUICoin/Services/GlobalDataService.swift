//
//  USADataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/29.
//

import Foundation
import Combine

class GlobalDataService {
    
    @Published var globals: [GlobalModel] = []
    
    var htmlScrapUtlity = USAScraperUtility()
    var coinSubscription: AnyCancellable?
    
    init() {
        getItem()
    }
    
    func getItem() {
        
        let urlString = "https://investing.com/"
        guard let url = URL(string: urlString) else { return print("scrap url error")}
        print("start Global scrap")
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map(\.data)
            .flatMap(htmlScrapUtlity.scrapGlobal(from:))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (globals) in
                self?.globals = globals
                print("scrap end")
                self?.coinSubscription?.cancel()
            }
    }
}

