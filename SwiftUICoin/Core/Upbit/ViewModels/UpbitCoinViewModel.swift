//
//  UpbitCoinViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import Foundation
import SwiftUI
import Combine

class UpbitViewModel: ObservableObject {
    
    @Published var winners = [UpbitTicker]()
    @Published var lossers = [UpbitTicker]()
    @Published var volume = [UpbitTicker]()
    
    private let queue = DispatchQueue.global()
    private let main = DispatchQueue.main
    private let dataService = UpbitRestApiService.shared
    private var cancellables = Set<AnyCancellable>()
    let webSocketService = UpbitWebSocketService.shared
    
    init() {
        fetchTickersFromRestApi()
        webSocketService.connect()
        sendToWebSocket()
    }
    
    func sendToWebSocket() {
        webSocketService.codesSubject
            .sink { [weak self] codes in
                self?.webSocketService.send()
            }
            .store(in: &cancellables)
    }
    
    func fetchTickersFromRestApi() {
        dataService.$tickers
            .sink { [weak self] tickers in
                self?.updateWinners(tickers: tickers)
                self?.updateLossers(tickers: tickers)
                self?.updateVolume(tickers: tickers)
            }
            .store(in: &cancellables)
    }
    
    private func updateWinners(tickers: [String: UpbitTicker]) {
        queue.async {
            let newArray = tickers.values.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
            self.main.async {
                self.winners = newArray
            }
        }
    }
    
    private func updateLossers(tickers: [String: UpbitTicker]) {
        queue.async {
            let newArray = tickers.values.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
            self.main.async {
                self.lossers = newArray
            }
        }
    }
    
    private func updateVolume(tickers: [String: UpbitTicker]) {
        queue.async {
            let newArray = tickers.values.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
            self.main.async {
                self.volume = newArray
            }
        }
    }
}





