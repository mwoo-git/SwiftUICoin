//
//  UpbitCoinViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation
import Combine

class UpbitCoinViewModel: ObservableObject {
    @Published var coins = [UpbitCoin]()
    @Published var displayedTickers = [UpbitTicker]()
    @Published var updatingTickers = [UpbitTicker]()
    @Published var isTimerRunning = false
    @Published var sortBy: TickerSortOption = .volume
    
    private lazy var dataService = UpbitCoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum TickerSortOption {
        case price
        case priceReversed
        case changeRate
        case changeRateReversed
        case volume
        case volumeReversed
    }
    
    init() {
        fetchCoins()
        fetchTickers()
        fetchTickersWithInterval()
    }
    
    func fetchCoins() {
        dataService.$coins
            .sink { [weak self] coins in
                self?.coins = coins
            }
            .store(in: &cancellables)
    }
    
    func fetchTickers() {
        dataService.$tickers
            .sink { [weak self] tickers in
                self?.updatingTickers = tickers
                if self?.displayedTickers.isEmpty ?? false {
                    self?.updateDisplayedTickers()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchTickersWithInterval() {
        var tickerTimer: AnyCancellable?
        $isTimerRunning
            .sink { [weak self] isTimerRunning in
                tickerTimer?.cancel()
                if isTimerRunning {
                    tickerTimer = Timer.publish(every: 1, on: .main, in: .common)
                        .autoconnect()
                        .sink { [weak self] _ in
                            self?.dataService.fetchTickers()
                        }
                }
            }
            .store(in: &cancellables)
    }
    
    func getKoreanName(for market: String) -> String {
        let coin = coins.first(where: { $0.market == market })
        return coin?.korean_name ?? ""
    }
    
    func updateDisplayedTickers() {
        $updatingTickers
            .combineLatest($sortBy)
            .map(sortTickers)
            .sink { [weak self] (tickers) in
                self?.displayedTickers = tickers
            }
            .store(in: &cancellables)
    }
    
    private func sortTickers(tickers: [UpbitTicker], sort: TickerSortOption) -> [UpbitTicker] {
        switch sort {
        case .price:
            return tickers.sorted(by: { $0.tradePrice > $1.tradePrice })
        case .priceReversed:
            return tickers.sorted(by: { $0.tradePrice < $1.tradePrice })
        case .changeRate:
            return tickers.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        case .changeRateReversed:
            return tickers.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        case .volume:
            return tickers.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        case .volumeReversed:
            return tickers.sorted(by: { $0.accTradePrice24H < $1.accTradePrice24H })
        }
    }
}





