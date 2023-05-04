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
    
    private var cancellables = Set<AnyCancellable>()
    
    init(keyword: String) {
        self.keyword = keyword
        fetchHeadlines(keyword: keyword)
    }
    
    private func fetchHeadlines(keyword: String) {
        Task {
            let headlines = try await HeadlineService.fetchArticles(withKeyword: keyword)
            await MainActor.run {
                self.headlines = headlines
            }
        }
    }
    
    func refreshHeadlines() {
        guard !isRefreshing else { return }
        fetchHeadlines(keyword: keyword)
        isRefreshing = true
        let refreshTime: Double = headlines.isEmpty ? 3 : 300
        DispatchQueue.main.asyncAfter(deadline: .now() + refreshTime) { [weak self] in
            self?.isRefreshing = false
        }
    }
}

