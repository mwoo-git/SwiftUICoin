//
//  Array.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/05.
//  @AppStorage에서 Array를 다룰 수 있도록 해주는 익스텐션입니다.

import Foundation

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
