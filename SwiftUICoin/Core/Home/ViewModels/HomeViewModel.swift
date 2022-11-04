//
//  HomeViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var backupCoins: [BackupCoinEntity] = []
    @Published var mainWatchlist: [CoinModel] = []
    @Published var subWatchlist: [CoinModel] = []
    @Published var mainWatchlistBackup: [BackupCoinEntity] = []
    @Published var subWatchlistBackup: [BackupCoinEntity] = []
    @Published var searchCoins: [CoinModel] = []
    @Published var searchCoinsBackup: [BackupCoinEntity] = []
    @Published var topMovingCoins: [CoinModel] = []
    @Published var lowMovingCoins: [CoinModel] = []
    @Published var sortOption: SortOption = .rank
    @Published var isRefreshing: Bool = false
    @Published var isEditing: Bool = false
    @Published var searchText: String = ""
    @Published var status: StatusCode = .status200
    @Published var trendCoins: [CoinModel] = []
    @Published var isDark: Bool = false
    
    private let dataService = CoinDataService()
    private let backupDataService = CoinBackupDataService()
    private let watchlistDataService = WatchlistDataService()
    private let trendCoinsDataService = TrendDataService()
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
                self?.updateBackup(coins: returnedCoins)
                self?.configureTopMovingCoins()
                self?.configurelowMovingCoins()
                self?.loadWatchlist()
            }
            .store(in: &cancellables)
        
        // Watchlist Update
        $allCoins
            .combineLatest(watchlistDataService.$savedEntities)
            .map(convertCoins)
            .sink { [weak self] (returnedCoins) in
                self?.subWatchlist = returnedCoins
            }
            .store(in: &cancellables)
        
        
        
        // SearchCoins Update
        $searchText // Subcriber
            .combineLatest($allCoins) // Subcriber
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
        // .debounce는 유저가 아무리 빠르게 타이핑해도 0.3초에 한번씩만 수행되도록 한다. 만약 설정하지 않는다면 유저가 빠르게 10자를 타이핑할 시 10번을 새롭게 수행하게 된다. 때문에 큰 데이터라면 좋지 않다.
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.searchCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Status Update
        dataService.$status
            .sink { [weak self] (statusCode) in
                self?.status = statusCode
            }
            .store(in: &cancellables)
        
        
        // BackupCoins Update
        backupDataService.$backupCoins
            .sink { [weak self] (returnedCoins) in
                self?.backupCoins = returnedCoins.sorted(by: { $0.rank < $1.rank })            }
            .store(in: &cancellables)
        
        $backupCoins
            .combineLatest(watchlistDataService.$savedEntities)
            .map(convertCoinsBackup)
            .sink { [weak self] (returnedCoins) in
                self?.subWatchlistBackup = returnedCoins
            }
            .store(in: &cancellables)
        
        trendCoinsDataService.$trendCoins
            .combineLatest($allCoins)
            .map(convertTrendCoins)
            .sink { [weak self] (returnedCoins) in
                self?.trendCoins = returnedCoins
            }
            .store(in: &cancellables)
        
    }
    
    func updateBackup(coins: [CoinModel]) {
        if backupDataService.backupCoins.isEmpty {
            backupDataService.updateBackup(coins: coins)
        }
    }
    
    func getCoin() {
        if allCoins.isEmpty {
            if !isRefreshing {
                dataService.getCoin()
                isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isRefreshing = false
                }
            }
        } else {
            if !isRefreshing {
                dataService.getCoin()
                isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
                    self.isRefreshing = false
                }
            }
        }
    }
    
    // Sort AllCoins
    private func sortCoins(coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        switch sort {
        case .rank:
            return coins.sorted(by: { $0.marketCapRank?.convertRank ?? 0 < $1.marketCapRank?.convertRank ?? 0 })
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
        mainWatchlist = subWatchlist.sorted(by: { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0 })
        mainWatchlistBackup = subWatchlistBackup.sorted(by: { $0.rank < $1.rank })
    }
    
    func isWatchlistExists(coin: CoinModel?, backup: BackupCoinEntity?) -> Bool {
        watchlistDataService.isWatchlistExists(coin: coin, backup: backup)
    }
    
    // Update Watchlist (Delete or add)
    func updateWatchlist(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            watchlistDataService.updateWatchlist(coin: nil, backup: backup)
        } else {
            watchlistDataService.updateWatchlist(coin: coin, backup: nil)
        }
        
    }
    
    
    private func convertTrendCoins(trendModels: [TrendModel], coinModels: [CoinModel]) -> [CoinModel] {
        trendModels
            .compactMap { (coin) in
                guard let convertCoin = coinModels.first(where: { $0.symbol == coin.symbol }) else { return nil }
                return convertCoin
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
    
    private func convertCoinsBackup(coinModels: [BackupCoinEntity], watchlistEntities: [WatchlistEntity]) -> [BackupCoinEntity] {
        coinModels
            .compactMap { (coin) -> BackupCoinEntity? in
                guard watchlistEntities.first(where: { $0.coinID == coin.id }) != nil else { return nil
                }
                return coin
            }
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        
        // text가 비어있지 않을 때만 계속 진행, 비어있다면 coins를 리턴하라
        guard !text.isEmpty else {
            return coins
        }
        
        // 입력된 문자를 소문자로 변환
        let lowercasedText = text.lowercased()
        
        // StartingCoins를 순회하며 조건값으로 필터링하고 리턴하라
        return coins.filter { (coin) -> Bool in
            
            // 요소의 name, symbol, id에 lowercasedText를 포함한 것을 반환하라
            return coin.name.lowercased().contains(lowercasedText) || // || 는 or "혹은"이라는 뜻
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func configureTopMovingCoins() {
        let topMovers = allCoins.sorted(by: { $0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0 })
        self.topMovingCoins = Array(topMovers.prefix(10))
    }
    
    private func configurelowMovingCoins() {
        let lowMovers = allCoins.sorted(by: { $0.priceChangePercentage24H ?? 0 < $1.priceChangePercentage24H ?? 0 })
        self.lowMovingCoins = Array(lowMovers.prefix(10))
    }
}
