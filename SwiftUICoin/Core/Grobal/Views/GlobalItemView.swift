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

struct GlobalItemView2: View {
    
    let global: GlobalModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(global.nameKR)
                    .bold()
                    .foregroundColor(Color.theme.textColor)
                Text(global.price)
                    .bold()
                    .foregroundColor(Color.theme.textColor)
                Text(global.priceChangePercentage)
                    .bold()
                    .padding(.trailing, 11)
                    .padding(.leading, 8)
                    .padding(.vertical, 3)
                    .font(.footnote)
                    .foregroundColor(Color.white)
                    .background(
                        global.priceChangePercentage.contains("+") ? Color.theme.red : Color.blue
                    )
                    .cornerRadius(5)
            }
            .font(.subheadline)
            .contentShape(Rectangle())
            .padding(.vertical, 10)
            Spacer()
        }
        .frame(width: 110)
    }
}

struct GlobalItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GlobalItemView(global: dev.global)
                .previewLayout(.sizeThatFits)
            GlobalItemView2(global: dev.global)
                .previewLayout(.sizeThatFits)
        }
    }
}
