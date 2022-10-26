//
//  SupportEmailModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/26.
//

import Foundation
import SwiftUI

struct SupportEmailModel {
    let toAddress: String
    let subject: String
    var body: String {"""
        의견을 보내주시면 더 나은 서비스 개발에 활용됩니다.
    """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("ERROR: 현재 기기는 이메일을 지원하지 않습니다.")
            }
        }
    }
}
