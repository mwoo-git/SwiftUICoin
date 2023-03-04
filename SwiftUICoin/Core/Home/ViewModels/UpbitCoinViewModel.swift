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
    
    private lazy var dataService = UpbitCoinDataService()
    private var coinCancellables: Set<AnyCancellable> = []
    private var tickerCancellables: Set<AnyCancellable> = []
    
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
            .store(in: &coinCancellables)
    }
    
    func fetchTickers() {
        dataService.$tickers
            .sink { [weak self] tickers in
                self?.updatingTickers = tickers
                if self?.displayedTickers.isEmpty ?? false {
                    self?.updateDisplayedTickers()
                }
            }
            .store(in: &tickerCancellables)
    }
    
    func updateDisplayedTickers() {
        displayedTickers = updatingTickers.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
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
            .store(in: &tickerCancellables)
    }
    
    func getKoreanName(for market: String) -> String? {
        if let coin = coins.first(where: { $0.market == market }) {
            return coin.korean_name
        }
        return nil
    }
}





