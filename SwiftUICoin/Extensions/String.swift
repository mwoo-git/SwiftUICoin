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
        case "klay":
            return "클레이튼"
        default:
            return self
        }
    }
    
    func base64Encoded() -> String? {
            if let data = self.data(using: .utf8) {
                return data.base64EncodedString()
            }
            return nil
        }
    
    func base64Decoded() -> String? {
            guard let data = Data(base64Encoded: self) else { return nil }
            return String(data: data, encoding: .utf8)
        }
}
