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
    private let main = DispatchQueue.main
    private var dataService = UpbitCoinDataService.shared
    private let webSocketService = UpbitWebSocketService.shared
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
        isWebSocketConnected()
    }
    
    func fetchCoins() {
        dataService.$coins
            .sink { [weak self] coins in
                self?.coins = coins
            }
            .store(in: &cancellables)
    }
    
    func sendToWebSocket() {
        codesSubject
            .debounce(for: .seconds(1), scheduler: queue)
            .sink { [weak self] codes in
                self?.webSocketService.send(codes: codes.joined(separator: ","))
            }
            .store(in: &cancellables)
    }
    
    func fetchTickersFromRestApi() {
        dataService.$tickers
            .combineLatest($sortBy)
            .receive(on: queue)
            .map(sortTickers)
            .receive(on: main)
            .sink { [weak self] tickers in
                self?.displayedTickers = tickers
            }
            .store(in: &cancellables)
    }
    
    func fetchTickersFromWebSocket() {
        webSocketService.tickerDictionarySubject
            .throttle(for: 1.0, scheduler: queue, latest: true)
            .receive(on: queue)
            .sink { [weak self] tickers in
                let mergedDictionary = self?.updatingTickers.merging(tickers) { $1 }
                self?.main.async {
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
    
    func codesFromCoins() -> String {
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
    
    private func isWebSocketConnected() {
        queue.async {
            self.webSocketService.$isConnected
                .filter { $0 == true }
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    let top10Markets = self.displayedTickers.prefix(10).map { $0.market }
                    self.webSocketService.send(codes: top10Markets.joined(separator: ","))
                    print("웹소켓 연결 후 재요청 완료")
                }
                .store(in: &self.cancellables)
        }
    }

    
    func connectWebSocket() {
            webSocketService.connect()
    }
    
    func closeWebSocket() {
        webSocketService.close()
    }
}





