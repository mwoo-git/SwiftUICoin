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
    
    @Published var allCoins = [CoinModel]()
    @Published var mainWatchlist = [CoinModel]()
    @Published var subWatchlist = [CoinModel]()
    @Published var searchCoins = [CoinModel]()
    @Published var topMovingCoins = [CoinModel]()
    @Published var lowMovingCoins = [CoinModel]()
    @Published var trendCoins = [CoinModel]()
    
    @Published var backupCoins = [BackupCoinEntity]()
    @Published var mainWatchlistBackup = [BackupCoinEntity]()
    @Published var subWatchlistBackup = [BackupCoinEntity]()
    @Published var searchCoinsBackup = [BackupCoinEntity]()
    
    @Published var status: StatusCode = .status200
    @Published var sortOption: CoingeckoSortOption = .rank
    @Published var isRefreshing = false
    @Published var isEditing = false
    @Published var isDark = true
    @Published var searchText = ""
    
    private lazy var dataService = CoinDataService()
    private lazy var backupDataService = CoinBackupDataService()
    private lazy var watchlistDataService = WatchlistDataService()
    private lazy var trendCoinsDataService = TrendDataService()
    private var cancellables = Set<AnyCancellable>()
    
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
                self?.configureLowMovingCoins()
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
        if isRefreshing {
            return
        }
        isRefreshing = true
        
        let refreshInterval: TimeInterval = allCoins.isEmpty ? 3 : 60
        dataService.getCoin()
        DispatchQueue.main.asyncAfter(deadline: .now() + refreshInterval) {
            self.isRefreshing = false
        }
    }
    
    // Sort AllCoins
    private func sortCoins(coins: [CoinModel], sort: CoingeckoSortOption) -> [CoinModel] {
        switch sort {
        case .rank:
            return coins.sorted(by: { ($0.marketCapRank?.convertRank ?? 0) < ($1.marketCapRank?.convertRank ?? 0) })
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .pricereversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
        case .priceChangePercentage24H:
            return coins.sorted(by: { ($0.priceChangePercentage24H ?? 0) > ($1.priceChangePercentage24H ?? 0)})
        case .priceChangePercentage24HReversed:
            return coins.sorted(by: { ($0.priceChangePercentage24H ?? 0) < ($1.priceChangePercentage24H ?? 0)})
        case .favorite:
            return coins.sorted(by: { ($0.marketCapRank?.convertRank ?? 0) < ($1.marketCapRank?.convertRank ?? 0) })
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
        watchlistDataService.updateWatchlist(coin: coin, backup: backup)
    }
    
    
    private func convertTrendCoins(trendModels: [TrendModel], coinModels: [CoinModel]) -> [CoinModel] {
        return trendModels.compactMap { trendModel in
            coinModels.first(where: { $0.symbol == trendModel.symbol })
        }
    }
    
    // AllCoins 중에 Watchlist에 해당되는 코인만 리턴
    private func convertCoins(coinModels: [CoinModel], watchlistEntities: [WatchlistEntity]) -> [CoinModel] {
        coinModels.filter { coin in
            watchlistEntities.first(where: { $0.coinID == coin.id }) != nil
        }
    }
    
    private func convertCoinsBackup(coinModels: [BackupCoinEntity], watchlistEntities: [WatchlistEntity]) -> [BackupCoinEntity] {
        coinModels.filter { coin in
            watchlistEntities.contains(where: { $0.coinID == coin.id })
        }
    }
    
    //Search
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        
        // text가 비어있지 않을 때만 계속 진행, 비어있다면 coins를 리턴하라
        guard !text.isEmpty else { return coins }
        
        // 입력된 문자를 소문자로 변환
        let lowercasedText = text.lowercased()
        
        // StartingCoins를 순회하며 조건값으로 필터링하고 리턴하라
        return coins.filter {
            
            // 요소의 name, symbol, id에 lowercasedText를 포함한 것을 반환하라
            $0.name.lowercased().contains(lowercasedText) ||
            $0.symbol.lowercased().contains(lowercasedText) ||
            $0.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(isTop: Bool) {
        let sortedCoins = allCoins.sorted(by: {
            let priceChange1 = $0.priceChangePercentage24H ?? 0
            let priceChange2 = $1.priceChangePercentage24H ?? 0
            return isTop ? (priceChange1 > priceChange2) : (priceChange1 < priceChange2)
        })
        self.topMovingCoins = isTop ? Array(sortedCoins.prefix(10)) : []
        self.lowMovingCoins = !isTop ? Array(sortedCoins.prefix(10)) : []
    }
    
    private func configureTopMovingCoins() {
        sortCoins(isTop: true)
    }
    
    private func configureLowMovingCoins() {
        sortCoins(isTop: false)
    }
    
    func getImageUrl(for symbol: String) -> String? {
        let coin = allCoins.first(where: { $0.symbol.lowercased() == symbol.lowercased() })
        return coin?.image
    }
}
