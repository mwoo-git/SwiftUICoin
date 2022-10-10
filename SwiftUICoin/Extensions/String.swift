//
//  String.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/23.
//

import Foundation

extension String {
    
    var removingHTMLOccurance: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var convertSymbol: String {
        switch self {
        case "btc":
            return "비트코인"
        case "eth":
            return "이더리움"
        case "sol":
            return "솔라나"
        case "xrp":
            return "리플"
        case "eos":
            return "이오스"
        case "ada":
            return "카르다노"
        case "doge":
            return "도지"
        case "matic":
            return "폴리곤"
        case "trx":
            return "트론"
        case "avax":
            return "아발란체"
        case "dot":
            return "폴카닷"
        default:
            return self
        }
    }
}
