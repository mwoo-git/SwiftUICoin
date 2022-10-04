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
    @Published var mainWatchlist: [CoinModel] = []
    @Published var subWatchlist: [CoinModel] = []
    @Published var sortOption: SortOption = .rank
    @Published var isRefreshing: Bool = false
    @Published var isEditing: Bool = false
    
    private let dataService = CoinDataService()
    private let watchlistDataService = WatchlistDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, price, pricereversed, priceChangePercentage24H, priceChangePercentage24HReversed
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
        
        // Watchlist Update
        $allCoins
            .combineLatest(watchlistDataService.$savedEntities)
            .map(convertCoins)
            .sink { [weak self] (returnCoins) in
                self?.subWatchlist = returnCoins
            }
            .store(in: &cancellables)

    }
    
    func getCoin() {
        dataService.getCoin()
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
            return coins.sorted(by: { $0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0})
        case .priceChangePercentage24HReversed:
            return coins.sorted(by: { $0.priceChangePercentage24H ?? 0 < $1.priceChangePercentage24H ?? 0})
        }
    }

    func isWatchlistEmpty() -> Bool {
        watchlistDataService.isWatchlistEmpty()
    }
    
    // reloadWatchlist
    func loadWatchlist() {
        mainWatchlist = subWatchlist
    }
    
    func isWatchlistExists(coin: CoinModel) -> Bool {
        watchlistDataService.isWatchlistExists(coin: coin)
    }
    
    // Update Watchlist (Delete or add)
    func updateWatchlist(coin: CoinModel) {
        watchlistDataService.updateWatchlist(coin: coin)
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
