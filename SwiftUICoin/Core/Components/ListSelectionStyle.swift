//
//  ListSelectionStyle.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/02.
//

import SwiftUI

struct ListSelectionStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.theme.listSelectionColor : Color.clear)
    }
}
