//
//  IconView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct IconView: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundColor(Color.theme.textColor)
            .font(.body)
            .frame(width: 30, height: 30)
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IconView(iconName: "magnifyingglass")
                .previewLayout(.sizeThatFits)
            
            IconView(iconName: "magnifyingglass")
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
