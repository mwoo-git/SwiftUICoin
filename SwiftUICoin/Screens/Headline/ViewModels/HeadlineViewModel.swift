//
//  HeadlineViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import Foundation
import Combine

class HeadlineViewModel: ObservableObject {
    
    @Published var headlines = [HeadlineModel]()
    @Published var isRefreshing = false
    @Published var keyword: String
    
    private var headlineDataService: HeadlineDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(keyword: String) {
        self.keyword = keyword
        self.headlineDataService = HeadlineDataService(keyword: keyword)
        subscribeToHeadlines()
    }
    
    private func subscribeToHeadlines() {
        headlineDataService.$headlines
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (newHeadlines) in
                self?.headlines = newHeadlines
                self?.isRefreshing = false
            }
            .store(in: &cancellables)
    }
    
    func refreshHeadlines() {
        if isRefreshing { return }
        
        headlineDataService.getArticles()
        isRefreshing = true
        let refreshTime: Double = headlines.isEmpty ? 3 : 300
        DispatchQueue.main.asyncAfter(deadline: .now() + refreshTime) { [weak self] in
            self?.isRefreshing = false
        }
    }
}

