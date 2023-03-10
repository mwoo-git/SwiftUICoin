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
    @Published var sortBy: TickerSortOption = .volume
    
    let codesSubject = CurrentValueSubject<[String], Never>([])
    var codes: [String] { codesSubject.value }
    
    let updatingTickersSubject = CurrentValueSubject<[String: UpbitTicker], Never>([:])
    var updatingTickers: [String: UpbitTicker] { updatingTickersSubject.value }
    
    private let queue = DispatchQueue.global()
    private var dataService = UpbitCoinDataService()
    private var webSocketService = UpbitWebSocketService()
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
        fetchTickersFromRestApi()
        fetchTickersFromWebSocket()
        webSocketService.connect()
        sendToWebSocket()
    }
    
    func fetchCoins() {
        dataService.$coins
            .sink { [weak self] coins in
                self?.coins = coins
            }
            .store(in: &cancellables)
    }
    
    func send(codes: String) {
        webSocketService.send(codes: codes)
    }
    
    func send1() {
        webSocketService.send(codes: "KRW-BTC")
    }
    
    func sendToWebSocket() {
        codesSubject
            .debounce(for: .seconds(1), scheduler: DispatchQueue.global())
            .sink { [weak self] codes in
                self?.webSocketService.send(codes: codes.joined(separator: ","))
            }
            .store(in: &cancellables)
    }
    
    func fetchTickersFromRestApi() {
        dataService.$tickers
            .combineLatest($sortBy)
            .receive(on: DispatchQueue.global())
            .map(sortTickers)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tickers in
                self?.displayedTickers = tickers
            }
            .store(in: &cancellables)
    }
    
    func fetchTickersFromWebSocket() {
        webSocketService.tickerDictionarySubject
            .throttle(for: 1.0, scheduler: DispatchQueue.global(), latest: true)
            .receive(on: DispatchQueue.global())
            .sink { [weak self] tickers in
                let mergedDictionary = self?.updatingTickers.merging(tickers) { $1 }
                DispatchQueue.main.async {
                    self?.updatingTickersSubject.send(mergedDictionary ?? [:])
                }
            }
            .store(in: &cancellables)
    }
    
    func getKoreanName(for market: String) -> String {
        let coin = coins.first(where: { $0.market == market })
        return coin?.korean_name ?? ""
    }
    
    private func sortTickers(tickers: [String: UpbitTicker], sort: TickerSortOption) -> [UpbitTicker] {
        var sortedTickers: [UpbitTicker] = []
        
        switch sort {
        case .price:
            sortedTickers = tickers.values.sorted(by: { $0.tradePrice > $1.tradePrice })
        case .priceReversed:
            sortedTickers = tickers.values.sorted(by: { $0.tradePrice < $1.tradePrice })
        case .changeRate:
            sortedTickers = tickers.values.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        case .changeRateReversed:
            sortedTickers = tickers.values.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        case .volume:
            sortedTickers = tickers.values.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        case .volumeReversed:
            sortedTickers = tickers.values.sorted(by: { $0.accTradePrice24H < $1.accTradePrice24H })
        }
        
        return sortedTickers
    }
    
    func marketsFromCoins() -> String {
        return coins.map { $0.market }.joined(separator: ",")
    }
    
    func appendCode(market: String) {
        queue.async {
            if !self.codes.contains(market) {
                self.codesSubject.value.append(market)
            }
        }
    }
    
    func deleteCode(market: String) {
        queue.async {
            self.codesSubject.value.removeAll(where: { $0 == market })
        }
    }
}





