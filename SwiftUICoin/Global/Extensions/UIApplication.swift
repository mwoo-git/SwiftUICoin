//
//  UIApplication.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/16.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
