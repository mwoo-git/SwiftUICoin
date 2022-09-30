//
//  WatchlistViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/29.
//

import Foundation
import Combine
import SwiftUI

class WatchlistViewModel: ObservableObject {

    @Published var reloadWatchCoins: [CoinModel] = []
    @Published var watchlistCoins: [CoinModel] = []
    @Published var isEditing: Bool = false
    @Published var isLoading: Bool = false
    
    private let watchlistDataService = WatchlistDataService()
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        dataService.$allCoins
            .combineLatest(watchlistDataService.$savedEntities)
            .map(convertCoins)
            .sink { [weak self] (returnCoins) in
                self?.watchlistCoins = returnCoins
            }
            .store(in: &cancellables)
        
        dataService.$isLoading
            .sink { [weak self] returnBool in
                self?.isLoading = returnBool
            }
            .store(in: &cancellables)
        
    }
    
    func isWatchlistEmpty() -> Bool {
        watchlistDataService.isWatchlistEmpty()
    }
    
    // reloadWatchlist
    func reloadWatchlist() {
        reloadWatchCoins = watchlistCoins
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
