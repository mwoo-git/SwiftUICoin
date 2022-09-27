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
    @Published var watchlistCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var sortOption: SortOption = .rank
    @Published var listOption: ListOption = .coin
    
    private let watchlistDataService = WatchlistDataService()
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
        
        // Update watchlist
        $allCoins
            .combineLatest(watchlistDataService.$savedEntities)
            .map(convertCoins)
            .sink { [weak self] (returnCoins) in
                self?.watchlistCoins = returnCoins
            }
            .store(in: &cancellables)
    }
    
    // Update Watchlist (Delete or add)
    func updateWatchlist(coin: CoinModel) {
        watchlistDataService.updateWatchlist(coin: coin)
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
    
    // AllCoins 중에 Watchlist에 해당되는 코인만 리턴
    private func convertCoins(coinModels: [CoinModel], watchlistEntities: [WatchlistEntity]) -> [CoinModel] {
        coinModels
            .compactMap { (coin) -> CoinModel? in
                guard watchlistEntities.first(where: { $0.coinID == coin.id }) != nil else { return nil
                }
                return coin
            }
    }
}
