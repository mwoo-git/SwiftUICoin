//
//  UpbitCoinViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation
import SwiftUI
import Combine

class UpbitCoinViewModel: ObservableObject {
    
    @Published var displayedTickers = [UpbitTicker]()
    @Published var sortBy: TickerSortOption = .changeRate
    
    private let queue = DispatchQueue.global()
    private let main = DispatchQueue.main
    private let dataService = UpbitRestApiService.shared
    private var cancellables = Set<AnyCancellable>()
    let webSocketService = UpbitWebSocketService.shared
    
    enum TickerSortOption {
        case price
        case priceReversed
        case changeRate
        case changeRateReversed
        case volume
        case volumeReversed
    }
    
    init() {
        fetchTickersFromRestApi()
        webSocketService.connect()
        sendToWebSocket()
        isWebSocketConnected()
    }
    
    func sendToWebSocket() {
        webSocketService.codesSubject
            .debounce(for: .seconds(1), scheduler: queue)
            .sink { [weak self] codes in
                self?.webSocketService.send()
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
    
    private func sortTickers(tickers: [String: UpbitTicker], sort: TickerSortOption) -> [UpbitTicker] {
        switch sort {
        case .price:
            return tickers.values.sorted(by: { $0.tradePrice > $1.tradePrice })
        case .priceReversed:
            return tickers.values.sorted(by: { $0.tradePrice < $1.tradePrice })
        case .changeRate:
            return tickers.values.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        case .changeRateReversed:
            return tickers.values.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        case .volume:
            return tickers.values.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        case .volumeReversed:
            return tickers.values.sorted(by: { $0.accTradePrice24H < $1.accTradePrice24H })
        }
    }
    
    func codesFromCoins() -> [String] {
//        return dataService.coins.map { $0.market }.joined(separator: ",")
        return dataService.coins.map { $0.market }

    }
    
    private func isWebSocketConnected() {
        queue.async {
            self.webSocketService.$isConnected
                .sink { [weak self] isConnected in
                    if isConnected {
                        guard let self = self else { return }
//                        let top10Markets = self.displayedTickers.prefix(10).map { $0.market }
                        let markets = self.displayedTickers.map { $0.market }
                        self.webSocketService.codesSubject.send(markets)
                        print("웹소켓 연결 후 코드 등록 완료")
                    }
                }
                .store(in: &self.cancellables)
        }
    }
}





