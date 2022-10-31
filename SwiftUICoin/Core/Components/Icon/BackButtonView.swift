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
        IconView(iconName: "chevron.left")
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
