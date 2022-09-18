//
//  CircleButtonView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct CircleButtonView: View {
    // 재사용 가능한 버튼뷰
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.subheadline)
            .foregroundColor(Color.white)
            .frame(width: 30, height: 30)
            .background(
                Circle()
                    .foregroundColor(Color.theme.arrowButton)
            )
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "arrow.right")
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            CircleButtonView(iconName: "arrow.right")
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}
