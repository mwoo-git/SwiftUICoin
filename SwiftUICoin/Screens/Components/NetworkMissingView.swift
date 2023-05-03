//
//  NetworkMissingVIew.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/15.
//

import SwiftUI

struct NetworkMissingView: View {
    
    @EnvironmentObject var monitor: NetworkMonitor
    
    var body: some View {
        Text(monitor.isConnected ? "인터넷에 다시 연결됨" : "연결되지 않음")
            .frame(width: UIScreen.main.bounds.width)
            .font(.footnote)
            .background((monitor.isConnected ? Color.theme.green : Color.black).ignoresSafeArea())
            .foregroundColor(Color.white)
            .animation(.easeInOut, value: monitor.showAlert)
    }
}

struct NetworkMissingVIew_Previews: PreviewProvider {
    static var previews: some View {
        NetworkMissingView()
            .previewLayout(.sizeThatFits)
    }
}
