//
//  GlobalItemView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/28.
//

import SwiftUI

struct GlobalItemView: View {
    
    let global: GlobalModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(global.nameKR)
                Text(global.price)
                    .font(.title2)
                    .bold()
                HStack {
                    Text(global.priceChange)
                    Text(global.priceChangePercentage)
                }
                .font(.subheadline)
                .foregroundColor(global.priceChangePercentage.contains("+") ? Color.theme.green : Color.theme.red)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}

struct GlobalItemView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalItemView(global: dev.global)
            .previewLayout(.sizeThatFits)
    }
}
