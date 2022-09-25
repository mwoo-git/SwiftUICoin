//
//  UIColor.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
