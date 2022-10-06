//
//  HeadlineViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation
import Combine

class HeadlineViewModel: ObservableObject {
    
    @Published var articles: [HeadlineModel] = []
    @Published var isRefreshing: Bool = false
    @Published var keyword: String
    
    private var headlineDataService: HeadlineDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(keyword: String) {
        self.keyword = keyword
        self.headlineDataService = HeadlineDataService(keyword: keyword)
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        headlineDataService.$articles
            .sink { [weak self] (returnedArticles) in
                self?.articles = returnedArticles
            }
            .store(in: &cancellables)
        
    }
    
    func getArticle() {
        if articles.isEmpty {
            headlineDataService.getArticles()
        } else {
            if !isRefreshing {
                headlineDataService.getArticles()
                isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
                    self.isRefreshing = false
                }
            }
        }
    }
}
