//
//  UINavigationController.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/11/02.

//  NavigationBarHidden을 하면 Swipe-Back 기능이 비활성화됩니다.
//  해당 익스텐션을 사용하여 Swipe-Back 기능을 활성화합니다.

import Foundation
import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
