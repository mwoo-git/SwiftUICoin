//
//  LaunchView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/11/16.
//

import SwiftUI

struct LaunchView: View {
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Text("Block Wide")
                .foregroundColor(Color.launch.text)
                .font(.title)
                .bold()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showLaunchView = false
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
