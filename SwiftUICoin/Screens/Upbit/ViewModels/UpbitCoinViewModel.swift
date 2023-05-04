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
    // MARK: - Properties
    
    @Published var winners = [UpbitTicker]()
    @Published var lossers = [UpbitTicker]()
    @Published var volume = [UpbitTicker]()
    
    var coins = [UpbitCoin]()

    let webSocketService = UpbitWebSocketService.shared
    
    // MARK: - Init
    
    init() {
        Task {
            await fetchCoins()
            await fetchTickers()
            await socketConnect()
        }
    }
    
    // MARK: - RestAPI
    
    func fetchCoins() async {
        do {
            let coins = try await UpbitService.fetchCoins()
            self.coins = coins
        } catch {
            print("DEBUG: fetchCoinsFromRestApi() Failed")
        }
    }
    
    func fetchTickers() async {
        do {
            let tickers = try await UpbitService.fetchTickers(withCoins: coins)
            Task { await updateWinners(tickers: tickers) }
            Task { await updateLossers(tickers: tickers) }
            Task { await updateVolume(tickers: tickers) }
        } catch {
            print("DEBUG: fetchTickersFromRestApi() Failed")
        }
    }
    
    // MARK: - Array
    
    private func updateWinners(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        await MainActor.run {
            self.winners = newArray
        }
    }
    
    private func updateLossers(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        await MainActor.run {
            self.lossers = newArray
        }
    }
    
    private func updateVolume(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        await MainActor.run {
            self.volume = newArray
        }
    }
    
    // MARK: - WebSocket
    
    func socketConnect() async {
        let codes = coins.map { $0.market }
        webSocketService.connect(withCodes: codes)
    }
    
    // MARK: - Reload
    
    func reload() {
        Task {
            await fetchTickers()
            await socketConnect()
        }
    }
}





