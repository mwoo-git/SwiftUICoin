//
//  UpbitCoinRowViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/07.
//

import Foundation
import SwiftUI
import Combine

class UpbitCoinRowViewModel: ObservableObject {
    @Published var market = ""
    @Published var change: Change = .natural
    @Published var showTicker = false
    @Published var price = ""
    @Published var changeRate = ""
    @Published var volume = ""
    @Published var color = Color.theme.textColor
    @Published var backgroundColor = Color.theme.background
    @Published var symbol = ""
    
    private var ticker: UpbitTicker
    private let main = DispatchQueue.main
    private let queue = DispatchQueue.global()
    private let dataService = UpbitRestApiService.shared
    private let webSocketService = UpbitWebSocketService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(ticker: UpbitTicker) {
        self.ticker = ticker
        self.price = ticker.formattedTradePrice
        self.changeRate = ticker.formattedChangeRate
        self.volume = ticker.formattedAccTradePrice24H
        self.market = ticker.market
        self.symbol = ticker.symbol
        addSubscriber()
    }
    
    enum Change: Equatable {
        case rise, fall, natural
    }
    
    private func addSubscriber() {
        queue.async {
            self.webSocketService.tickerDictionarySubject
                .throttle(for: 1.0, scheduler: self.queue, latest: true)
                .receive(on: self.queue)
                .sink { [weak self] tickers in
                    self?.updateView(tickers: tickers)
                }
                .store(in: &self.cancellables)
        }
    }
    
    private func updateView(tickers: [String: UpbitTicker]) {
        queue.async {
            guard self.showTicker else {
                return
            }
            if let updatedTicker = tickers[self.market], updatedTicker.formattedTradePrice != self.price {
                let newPrice = updatedTicker.formattedTradePrice
                self.main.async {
                    if self.price < newPrice {
                        self.color = Color.theme.risingColor
                        self.backgroundColor = Color.theme.risingColor.opacity(0.05)
                    } else {
                        self.color = Color.theme.fallingColor
                        self.backgroundColor = Color.theme.fallingColor.opacity(0.05)
                    }
                    self.price = updatedTicker.formattedTradePrice
                    self.changeRate = updatedTicker.formattedChangeRate
                    self.volume = updatedTicker.formattedAccTradePrice24H
                }
                self.main.asyncAfter(deadline: .now() + 0.5) {
                    self.color = Color.theme.textColor
                    self.backgroundColor = Color.theme.background
                }
            }
        }
    }
    
    func changeColor() {
        main.async {
            switch self.change {
            case .rise:
                self.color = Color.theme.red
            case .fall:
                self.color = Color.theme.openseaColor
            case .natural:
                self.color = Color.theme.textColor
            }
        }
    }
    
    func appendCode(market: String) {
        queue.async {
            if !self.webSocketService.codes.contains(market) {
                self.webSocketService.codesSubject.value.append(market)
            }
        }
    }
    
    func deleteCode(market: String) {
        queue.async {
            self.webSocketService.codesSubject.value.removeAll(where: { $0 == market })
        }
    }
    
    func koreanName() -> String {
        let coin = dataService.coins.first(where: { $0.market == market })
        return coin?.korean_name ?? ""
    }
}
