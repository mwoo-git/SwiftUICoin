//
//  BackButtonView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/27.
//

import SwiftUI

struct BackButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Image(systemName: "chevron.left")
            .foregroundColor(Color.theme.textColor)
            .font(.title3)
            .frame(width: 50, height: 50)
            .onTapGesture {
                withAnimation() {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .contentShape(Rectangle())
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView()
    }
}
