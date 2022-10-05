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
    
    private var headlineDataService = HeadlineDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
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
        headlineDataService.getArticles()
        print("get articles")
    }
    
}
