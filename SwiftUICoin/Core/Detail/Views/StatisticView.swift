//
//  StatisticView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/21.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        HStack {
            Text(stat.title)
                .foregroundColor(Color.theme.accent)
            Spacer()
            Text(stat.value)
        }
        .padding()
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.stat)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            StatisticView(stat: dev.stat)
                .previewLayout(.sizeThatFits)
        }
    }
}
