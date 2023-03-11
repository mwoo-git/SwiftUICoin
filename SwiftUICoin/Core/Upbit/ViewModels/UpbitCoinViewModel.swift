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
    @Published var sortBy: TickerSortOption = .volume
    @Published var scrollViewOffset: CGFloat = 0
    @Published var isScrolling = false
    
    private let queue = DispatchQueue.global()
    private let main = DispatchQueue.main
    private let dataService = UpbitCoinDataService.shared
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
        return dataService.coins.map { $0.market }.joined(separator: ",")
    }
    
    private func isWebSocketConnected() {
        queue.async {
            self.webSocketService.$isConnected
                .sink { [weak self] isConnected in
                    if isConnected {
                        guard let self = self else { return }
                        let top10Markets = self.displayedTickers.prefix(10).map { $0.market }
                        self.webSocketService.codesSubject.send(top10Markets)
                        print("웹소켓 연결 후 코드 등록 완료")
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    func listGeometryReader() -> some View {
        GeometryReader { proxy -> Color in
            let offsetY = proxy.frame(in: .named("scrollView")).minY
            let newOffset = min(0, offsetY)
            if self.scrollViewOffset != newOffset {
                self.main.async {
                    self.isScrolling = true
                }
                self.main.asyncAfter(deadline: .now() + 0.2) {
                    self.scrollViewOffset = newOffset
                }
            } else {
                self.main.async {
                    self.isScrolling = false
                }
            }
            return Color.clear
        }
    }
}





