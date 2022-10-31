//
//  GlobalModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/28.
//

import Foundation

struct GlobalModel: Codable, Identifiable {
    var id: UUID
    let name: String
    let price: String
    let priceChange: String
    let priceChangePercentage: String
    
    init(id: UUID = UUID(), name: String, price: String, priceChange: String, priceChangePercentage: String) {
        self.id = id
        self.name = name
        self.price = price
        self.priceChange = priceChange
        self.priceChangePercentage = priceChangePercentage
    }
    
    var nameKR: String {
        switch name {
        case "US 30":
            return "다우 선물"
        case "US 500":
            return "S&P 500 선물"
        case "Dow Jones":
            return "다우존스"
        case "Nasdaq":
            return "나스닥"
        case "Dollar Index":
            return "미국 달러 지수"
        case "Crude Oil WTI":
            return "WTI"
        case "Natural Gas":
            return "천연 가스"
        case "Gold":
            return "금"
        case "Silver":
            return "은"
        case "Copper":
            return "구리"
        case "US Soybeans":
            return "미국 콩"
        case "Apple":
            return "애플"
        case "Alphabet A":
            return "구글"
        case "Tesla":
            return "테슬라"
        case "Amazon.com":
            return "아마존"
        case "Netflix":
            return "넷플릭스"
        case "Meta Platforms":
            return "메타"
        default:
            return name
        }
    }
    
    var symbol: String {
        switch name {
        case "US 30":
            return "CURRENCYCOM:US30"
        case "US 500":
            return "CURRENCYCOM:US500"
        case "S&P 500":
            return "CURRENCYCOM:US500"
        case "Dow Jones":
            return "FOREXCOM:DJI"
        case "Nasdaq":
            return "NASDAQ:IXIC"
        case "Dollar Index":
            return "CAPITALCOM:DXY"
        case "Crude Oil WTI":
            return "NYMEX:CL1!"
        case "Natural Gas":
            return "NYMEX:NG1!"
        case "Gold":
            return "COMEX:GC1!"
        case "Silver":
            return "COMEX:SI1!"
        case "Copper":
            return "COMEX:HG1!"
        case "US Soybeans":
            return "CBOT:ZS1!"
        case "Apple":
            return "NASDAQ:AAPL"
        case "Alphabet A":
            return "NASDAQ:GOOGL"
        case "Tesla":
            return "NASDAQ:TSLA"
        case "Amazon.com":
            return "NASDAQ:AMZN"
        case "Netflix":
            return "NASDAQ:NFLX"
        case "Meta Platforms":
            return "NASDAQ:META"
        default:
            return name
        }
    }
}
