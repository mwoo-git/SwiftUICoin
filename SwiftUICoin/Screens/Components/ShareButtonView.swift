//
//  ShareButtonView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/16.
//

import SwiftUI

struct ShareButtonView: View {
    
    @State private var isShareSheetShowing: Bool = false
    
    let url: String
    
    var body: some View {
        Button(action: shareButton) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(Color.theme.textColor)
                .font(.headline)
                .padding(.horizontal)
                .frame(width: 50, height: 50)
        }
    }
    
    func shareButton() {
        isShareSheetShowing.toggle()
        
        let url = URL(string: url)
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct ShareButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView(url: "www.google.com")
    }
}
