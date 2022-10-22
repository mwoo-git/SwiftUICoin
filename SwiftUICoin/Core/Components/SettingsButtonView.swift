//
//  SettingsButtonView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/23.
//

import SwiftUI

struct SettingsButtonView: View {
    var body: some View {
        NavigationLink(
            destination: SettingsView()) {
                IconView(iconName: "person.circle")
            }
    }
}

struct SettingsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButtonView()
    }
}
