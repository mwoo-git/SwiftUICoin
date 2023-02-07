//
//  HeadlineViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation
import Combine

class HeadlineViewModel: ObservableObject {
    
    @Published var articles = [HeadlineModel]()
    @Published var isRefreshing = false
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (returnedArticles) in
                self?.articles = returnedArticles
                self?.isRefreshing = false
            }
            .store(in: &cancellables)
    }
    
    func getArticle() {
        if isRefreshing { return }
        
        headlineDataService.getArticles()
        isRefreshing = true
        let refreshTime: Double = articles.isEmpty ? 3 : 300
        DispatchQueue.main.asyncAfter(deadline: .now() + refreshTime) { [weak self] in
            self?.isRefreshing = false
        }
    }
}

