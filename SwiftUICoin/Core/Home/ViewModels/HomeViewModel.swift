//
//  HomeViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var sortOption: SortOption = .rank
    @Published var listOption: ListOption = .coin
    @Published var isLoading: Bool = false
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, price, pricereversed, priceChangePercentage24H, priceChangePercentage24HReversed
    }
    
    enum ListOption {
        case watchlist, coin
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // AllCoins Update
        dataService.$allCoins
            .combineLatest($sortOption) // Subcriber
            .map(sortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        dataService.$isLoading
            .sink { [weak self] returnBool in
                self?.isLoading = returnBool
            }
            .store(in: &cancellables)
        
    }
    
    // Sort AllCoins
    private func sortCoins(coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        switch sort {
        case .rank:
            return coins.sorted(by: { $0.rank < $1.rank })
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .pricereversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
        case .priceChangePercentage24H:
            return coins.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H})
        case .priceChangePercentage24HReversed:
            return coins.sorted(by: { $0.priceChangePercentage24H < $1.priceChangePercentage24H})
        }
    }
}
