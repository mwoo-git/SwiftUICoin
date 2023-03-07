//
//  UpbitCoinRowViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/07.
//

import Foundation
import SwiftUI

class UpbitCoinRowViewModel: ObservableObject {
    @Published var market = ""
    @Published var change: Change = .natural
    @Published var showTicker = false
    @Published var price = ""
    @Published var changeRate = ""
    @Published var volume = ""
    @Published var color = Color.theme.textColor
    
    
    enum Change: Equatable {
        case rise, fall, natural
    }
    
    func updateView(tickers: [UpbitTicker]) {
        guard showTicker else {
            return
        }
        
        if let updatedTicker = tickers.first(where: { $0.market == market }), updatedTicker.formattedTradePrice != price {
            let newPrice = updatedTicker.formattedTradePrice
            if self.price < newPrice {
                self.color = Color.theme.red
            } else {
                self.color = Color.theme.openseaColor
            }
            DispatchQueue.main.async {
                self.price = updatedTicker.formattedTradePrice
                self.changeRate = updatedTicker.formattedChangeRate
                self.volume = updatedTicker.formattedAccTradePrice24H
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.color = Color.theme.textColor
            }
        }
    }
    
    func changeColor() {
        DispatchQueue.main.async {
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
}
