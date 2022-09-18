//
//  TotalBalanceView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/17.
//

import SwiftUI

struct TotalBalanceView: View {
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("Total Balance")
                    IconView(iconName: "eye")
                        .padding(.leading, -5)
                }
                .font(.subheadline)
                Text("$12,345.67")
                    .font(.title)
                    .fontWeight(.semibold)
                
            }
            Spacer()
            CircleButtonView(iconName: "arrow.right")
        }
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom, 35)
    }
}

struct TotalBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        TotalBalanceView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
