//
//  Color.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/11.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
    
}

struct ColorTheme {
    
    let accent = Color("SecondaryTextColor")
    let background = Color("BackgroundColor")
    let DarkBackgroundColor = Color("DarkBackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    let arrowButton = Color("ArrowButtonColor")
    let sortOptionColor = Color("SortOptionColor")
    let binanceColor = Color("BinanceColor")
    let searchBar = Color("SearchBarColor")
    let iconColor = Color("IconColor")
    let textColor = Color("TextColor")
    let openseaColor = Color("OpenSeaColor")
    let listSelectionColor = Color("ListSelectionColor")
    let globalItemGreenColor = Color("GlobalItemGreenColor")
}

struct LaunchTheme {
    let text = Color("LaunchTextColor")
    let background = Color("LaunchBackgroundColor")
}
