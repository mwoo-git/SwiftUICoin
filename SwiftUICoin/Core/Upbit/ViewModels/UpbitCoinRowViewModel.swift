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
    @Published var opacity = 0.1
    
    private var ticker: UpbitTicker
    private var coin: UpbitCoin
    private let main = DispatchQueue.main
    private let queue = DispatchQueue.global()
    private let webSocketService = UpbitWebSocketService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(ticker: UpbitTicker, coin: UpbitCoin) {
        self.ticker = ticker
        self.coin = coin
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
                .throttle(for: 0.5, scheduler: self.queue, latest: true)
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
                        //                        self.color = Color.theme.risingColor
                        //                        self.backgroundColor = Color.theme.risingColor.opacity(0.05)
                        self.opacity = 0.2
                        
                    } else {
                        //                        self.color = Color.theme.fallingColor
                        //                        self.backgroundColor = Color.theme.fallingColor.opacity(0.05)
                        self.opacity = 0.2
                    }
                    self.price = updatedTicker.formattedTradePrice
                    self.changeRate = updatedTicker.formattedChangeRate
                    self.volume = updatedTicker.formattedAccTradePrice24H
                }
                self.main.asyncAfter(deadline: .now() + 0.2) {
                    //                    self.color = Color.theme.textColor
                    //                    self.backgroundColor = Color.theme.background
                    withAnimation {
                        self.opacity = 0.1
                    }
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
    
    func koreanName() -> String {
        return coin.korean_name
    }
}
